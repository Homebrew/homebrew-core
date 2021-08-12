class Openjdk < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  if Hardware::CPU.arm?
    # Temporarily use a openjdk 17 preview on Apple Silicon
    # (because it is better than nothing)
    url "https://github.com/openjdk/jdk/archive/refs/tags/jdk-17+31.tar.gz"
    sha256 "9a658a42b2fe3b64ef3b2617395fc8f442f046e43e52b1d3b3a6a9b83d32b2ce"
    version "16.0.2"
  else
    url "https://github.com/openjdk/jdk16u/archive/refs/tags/jdk-16.0.2-ga.tar.gz"
    sha256 "d1b01bb5e710a973256a11fe852b7e23523ca8ef04997fa29cf459ba5303a476"
  end
  license "GPL-2.0-only" => { with: "Classpath-exception-2.0" }

  livecheck do
    url "https://github.com/openjdk/jdk#{version.major}u/releases"
    strategy :page_match
    regex(/>\s*?jdk[._-]v?(\d+(?:\.\d+)*)-ga\s*?</i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "83b39e22b91173ee797b09e11bbcb08b3cff5c3aeed65f64cb5f8c43d474500c"
    sha256 cellar: :any, big_sur:       "fb57725b9d1ac7dc846842c4905630ebe6878242cd876dc23d00d3100e6d4e26"
    sha256 cellar: :any, catalina:      "71fe0d7fb0120bb7fdb011cb9ecb107413920f97eb54f53770649f63c9780a56"
    sha256 cellar: :any, mojave:        "d92651670572e834a36ca2af789646a28c4745930c19a3468b92834da9a0f1a1"
    sha256               x86_64_linux:  "2627c93c2209e9da424ebba280d1fd6fceded687c9d449af4c41bb0639f3a01b"
  end

  keg_only :shadowed_by_macos

  depends_on "autoconf" => :build
  depends_on xcode: :build if Hardware::CPU.arm?

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "cups"
    depends_on "fontconfig"
    depends_on "gcc"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxrandr"
    depends_on "libxrender"
    depends_on "libxt"
    depends_on "libxtst"
    depends_on "unzip"
    depends_on "zip"

    ignore_missing_libraries "libjvm.so"
  end

  fails_with gcc: "5"

  # From https://jdk.java.net/archive/
  resource "boot-jdk" do
    on_macos do
      if Hardware::CPU.arm?
        url "https://download.java.net/java/early_access/jdk17/31/GPL/openjdk-17-ea+31_macos-aarch64_bin.tar.gz"
        sha256 "bf0acde8615ad1bef9c3696128531bec13bcdc3c28baca687bab6902c4b5c7f7"
      else
        url "https://download.java.net/java/GA/jdk15.0.2/0d1cfde4252546c6931946de8db48ee2/7/GPL/openjdk-15.0.2_osx-x64_bin.tar.gz"
        sha256 "578b17748f5a7d111474bc4c9b5a8a06b4a4aa1ba4a4bc3fef014e079ece7c74"
      end
    end
    on_linux do
      url "https://download.java.net/java/GA/jdk15.0.2/0d1cfde4252546c6931946de8db48ee2/7/GPL/openjdk-15.0.2_linux-x64_bin.tar.gz"
      sha256 "91ac6fc353b6bf39d995572b700e37a20e119a87034eeb939a6f24356fbcd207"
    end
  end

  def install
    boot_jdk = Pathname.pwd/"boot-jdk"
    resource("boot-jdk").stage boot_jdk
    on_macos do
      boot_jdk /= "Contents/Home"
    end
    java_options = ENV.delete("_JAVA_OPTIONS")

    args = %W[
      --disable-warnings-as-errors
      --with-boot-jdk-jvmargs=#{java_options}
      --with-boot-jdk=#{boot_jdk}
      --with-debug-level=release
      --with-jvm-variants=server
      --with-native-debug-symbols=none
      --with-vendor-bug-url=#{tap.issues_url}
      --with-vendor-name=#{tap.user}
      --with-vendor-url=#{tap.issues_url}
      --with-vendor-version-string=#{tap.user}
      --with-vendor-vm-bug-url=#{tap.issues_url}
      --with-version-build=#{revision}
      --without-version-opt
      --without-version-pre
    ]

    framework_path = nil
    on_macos do
      args += %W[
        --enable-dtrace
        --with-extra-ldflags=-headerpad_max_install_names
        --with-sysroot=#{MacOS.sdk_path}
      ]

      if Hardware::CPU.arm?
        # Path to dual-arch JavaNativeFoundation.framework from Xcode
        framework_path = File.expand_path(
          "../SharedFrameworks/ContentDeliveryServices.framework/Versions/Current/itms/java/Frameworks",
          MacOS::Xcode.prefix,
        )

        args += %W[
          --openjdk-target=aarch64-apple-darwin
          --with-build-jdk=#{boot_jdk}
          --with-extra-cflags=-arch\ arm64
          --with-extra-cxxflags=-arch\ arm64
          --with-extra-ldflags=-arch\ arm64\ -F#{framework_path}
        ]
      end
    end

    on_linux do
      args += %W[
        --with-x=#{HOMEBREW_PREFIX}
        --with-cups=#{HOMEBREW_PREFIX}
        --with-fontconfig=#{HOMEBREW_PREFIX}
      ]
    end

    chmod 0755, "configure"
    system "./configure", *args

    ENV["MAKEFLAGS"] = "JOBS=#{ENV.make_jobs}"
    system "make", "images"

    on_macos do
      jdk = Dir["build/*/images/jdk-bundle/*"].first
      libexec.install jdk => "openjdk.jdk"
      bin.install_symlink Dir[libexec/"openjdk.jdk/Contents/Home/bin/*"]
      include.install_symlink Dir[libexec/"openjdk.jdk/Contents/Home/include/*.h"]
      include.install_symlink Dir[libexec/"openjdk.jdk/Contents/Home/include/darwin/*.h"]
      man1.install_symlink Dir[libexec/"openjdk.jdk/Contents/Home/man/man1/*"]

      if Hardware::CPU.arm?
        dest = libexec/"openjdk.jdk/Contents/Home/lib/JavaNativeFoundation.framework"
        # Copy JavaNativeFoundation.framework from Xcode
        # https://gist.github.com/claui/ea4248aa64d6a1b06c6d6ed80bc2d2b8#gistcomment-3539574
        cp_r "#{framework_path}/JavaNativeFoundation.framework", dest, remove_destination: true

        # Replace Apple signature by ad-hoc one (otherwise relocation will break it)
        system "codesign", "-f", "-s", "-", dest/"Versions/A/JavaNativeFoundation"
      end
    end

    on_linux do
      libexec.install Dir["build/linux-x86_64-server-release/images/jdk/*"]
      bin.install_symlink Dir[libexec/"bin/*"]
      include.install_symlink Dir[libexec/"include/*.h"]
      include.install_symlink Dir[libexec/"include/linux/*.h"]
      man1.install_symlink Dir[libexec/"man/man1/*"]
    end
  end

  def caveats
    on_macos do
      s = <<~EOS
        For the system Java wrappers to find this JDK, symlink it with
          sudo ln -sfn #{opt_libexec}/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
      EOS

      if Hardware::CPU.arm?
        s += <<~EOS
          This is a beta version of openjdk for Apple Silicon
          (openjdk 17 preview).
        EOS
      end

      s
    end
  end

  test do
    (testpath/"HelloWorld.java").write <<~EOS
      class HelloWorld {
        public static void main(String args[]) {
          System.out.println("Hello, world!");
        }
      }
    EOS

    system bin/"javac", "HelloWorld.java"

    assert_match "Hello, world!", shell_output("#{bin}/java HelloWorld")
  end
end
