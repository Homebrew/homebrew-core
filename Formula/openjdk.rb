class Openjdk < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  if Hardware::CPU.arm?
    # Temporarily use a openjdk 17 preview on Apple Silicon
    # (because it is better than nothing)
    url "https://github.com/openjdk/jdk/archive/refs/tags/jdk-17+24.tar.gz"
    sha256 "9d1ea3fc63ce860e55a9be77f670b18fa7b7e5c9773dca3c70042403e1ee285c"
    version "16.0.1"
  else
    url "https://github.com/openjdk/jdk16u/archive/refs/tags/jdk-16.0.1-ga.tar.gz"
    sha256 "ef53ef8796080a955efbfdbf05ea137ff95ac6d444dab3b2fcd57c9709a3b65d"
  end
  license "GPL-2.0-only" => { with: "Classpath-exception-2.0" }

  livecheck do
    url "https://github.com/openjdk/jdk#{version.major}u/releases"
    strategy :page_match
    regex(/>\s*?jdk[._-]v?(\d+(?:\.\d+)*)-ga\s*?</i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "040b807b1c754ccbb5316484a42089e64d29f0321dc6531017020095b8222c7a"
    sha256 cellar: :any, big_sur:       "55c120ab6b02ddcf7f3f22678377d70c89ac625239b5af396c60a9b2840f0995"
    sha256 cellar: :any, catalina:      "04435cc60a4cdf18dade6923a8a039a8ed22ff900068ec95c250f7ea055f381a"
    sha256 cellar: :any, mojave:        "ea08c6570290923349fa4f908070445c0c4dd5fef9e65b401eb2323f0a8fddd6"
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
  end

  fails_with gcc: "5"

  # From https://jdk.java.net/archive/
  resource "boot-jdk" do
    on_macos do
      if Hardware::CPU.arm?
        url "https://download.java.net/java/early_access/jdk17/24/GPL/openjdk-17-ea+24_macos-aarch64_bin.tar.gz"
        sha256 "176ab64ad860e363428ce3e4b23e8207576f8a65a567761475281cda25887640"
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
      bin.install_symlink Dir["#{libexec}/openjdk.jdk/Contents/Home/bin/*"]
      include.install_symlink Dir["#{libexec}/openjdk.jdk/Contents/Home/include/*.h"]
      include.install_symlink Dir["#{libexec}/openjdk.jdk/Contents/Home/include/darwin/*.h"]

      if Hardware::CPU.arm?
        dest = libexec/"openjdk.jdk/Contents/Home/lib/JavaNativeFoundation.framework"
        # Copy JavaNativeFoundation.framework from Xcode
        # https://gist.github.com/claui/ea4248aa64d6a1b06c6d6ed80bc2d2b8#gistcomment-3539574
        cp_r "#{framework_path}/JavaNativeFoundation.framework", dest, remove_destination: true

        # Replace Apple signature by ad-hoc one (otherwise relocation will break it)
        system "codesign", "-f", "-s", "-", "#{dest}/Versions/A/JavaNativeFoundation"
      end
    end

    on_linux do
      libexec.install Dir["build/linux-x86_64-server-release/images/jdk/*"]
      bin.install_symlink Dir["#{libexec}/bin/*"]
      include.install_symlink Dir["#{libexec}/include/*.h"]
      include.install_symlink Dir["#{libexec}/include/linux/*.h"]
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
