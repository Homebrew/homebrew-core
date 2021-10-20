class OpenjdkAT11 < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  license "GPL-2.0-only"

  if Hardware::CPU.arm?
    # Temporarily use build of unreleased openjdk 11.0.15 on Apple Silicon
    url "https://github.com/openjdk/jdk11u/archive/refs/tags/jdk-11.0.15+5.tar.gz"
    sha256 "c541dbc147a40b9cce987d4831970b96bb843471541bb25a140bbbfbd3e056de"
    version "11.0.14.1"
  else
    url "https://github.com/openjdk/jdk11u/archive/refs/tags/jdk-11.0.14.1-ga.tar.gz"
    sha256 "27244faf7e34e66a0ca4bb6ebbbe8bf4884d4e2d93028bd99c1511304f27bac4"
  end

  livecheck do
    url :stable
    regex(/^jdk[._-]v?(11(?:\.\d+)*)-ga$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "dbf0b347060474c1aa0fbe3e58e33f4d81337e6f49209761da130ee776d66355"
    sha256 cellar: :any,                 big_sur:       "2de8af552742c3caa4d19fa15f6c39c771c20684c0afc0ebaa1e5f9b1ce1801a"
    sha256 cellar: :any,                 catalina:      "339415a28991471cad033b5025c37e0b235338379b51dbd1b94551b721f6e1b2"
    sha256 cellar: :any,                 mojave:        "73ff7dac9d97a48cf4774c4c68ee265dab978fa061f65c11ac5889c18845bffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "771eae7321e5178e5dd95db8c115e75a8697ece61387723e83dfeae5b0f466c4"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on xcode: :build if Hardware::CPU.arm?

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "cups"
    depends_on "fontconfig"
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

  resource "boot-jdk" do
    on_macos do
      if Hardware::CPU.arm?
        url "https://cdn.azul.com/zulu/bin/zulu11.54.25-ca-jdk11.0.14.1-macosx_aarch64.tar.gz"
        sha256 "2076f8ce51c0e9ad7354e94b79513513b1697aa222f9503121d800c368b620a3"
      else
        url "https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_osx-x64_bin.tar.gz"
        sha256 "77ea7675ee29b85aa7df138014790f91047bfdafbc997cb41a1030a0417356d7"
      end
    end
    on_linux do
      url "https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz"
      sha256 "f3b26abc9990a0b8929781310e14a339a7542adfd6596afb842fa0dd7e3848b2"
    end
  end

  def install
    boot_jdk = Pathname.pwd/"boot-jdk"
    resource("boot-jdk").stage boot_jdk
    boot_jdk /= "Contents/Home" if OS.mac? && !Hardware::CPU.arm?
    java_options = ENV.delete("_JAVA_OPTIONS")

    args = %W[
      --disable-hotspot-gtest
      --disable-warnings-as-errors
      --with-boot-jdk-jvmargs=#{java_options}
      --with-boot-jdk=#{boot_jdk}
      --with-debug-level=release
      --with-conf-name=release
      --with-jvm-variants=server
      --with-native-debug-symbols=none
      --with-vendor-bug-url=#{tap.issues_url}
      --with-vendor-name=#{tap.user}
      --with-vendor-url=#{tap.issues_url}
      --with-vendor-version-string=#{tap.user}
      --with-vendor-vm-bug-url=#{tap.issues_url}
      --without-version-opt
      --without-version-pre
    ]

    if OS.mac?
      framework_path = File.expand_path(
        "../SharedFrameworks/ContentDeliveryServices.framework/Versions/Current/itms/java/Frameworks",
        MacOS::Xcode.prefix,
      )

      args += ["--with-sysroot=#{MacOS.sdk_path}", "--enable-dtrace=auto"]

      if Hardware::CPU.arm?
        args += [
          "--openjdk-target=aarch64-apple-darwin",
          "--with-build-jdk=#{boot_jdk}",
          "--with-extra-cflags=-arch arm64",
          "--with-extra-ldflags=-arch arm64 -F#{framework_path} -headerpad_max_install_names",
          "--with-extra-cxxflags=-arch arm64",
        ]
      else
        args << "--with-extra-ldflags=-headerpad_max_install_names"
      end
    else
      args << "--with-x=#{HOMEBREW_PREFIX}"
      args << "--with-cups=#{HOMEBREW_PREFIX}"
      args << "--with-fontconfig=#{HOMEBREW_PREFIX}"
    end

    chmod 0755, "configure"
    system "./configure", *args

    ENV["MAKEFLAGS"] = "JOBS=#{ENV.make_jobs}"
    system "make", "images", "CONF=release"

    cd "build/release/images" do
      jdk = libexec
      if OS.mac?
        libexec.install Dir["jdk-bundle/*"].first => "openjdk.jdk"
        jdk /= "openjdk.jdk/Contents/Home"

        if Hardware::CPU.arm?
          # Copy JavaNativeFoundation.framework from Xcode
          # https://gist.github.com/claui/ea4248aa64d6a1b06c6d6ed80bc2d2b8#gistcomment-3539574
          dest = jdk/"lib/JavaNativeFoundation.framework"
          cp_r "#{framework_path}/JavaNativeFoundation.framework", dest, remove_destination: true

          # Replace Apple signature by ad-hoc one (otherwise relocation will break it)
          system "codesign", "-f", "-s", "-", dest/"Versions/A/JavaNativeFoundation"
        end
      else
        libexec.install Dir["jdk/*"]
      end

      bin.install_symlink Dir[jdk/"bin/*"]
      include.install_symlink Dir[jdk/"include/*.h"]
      include.install_symlink Dir[jdk/"include/*/*.h"]
      man1.install_symlink Dir[jdk/"man/man1/*"]
    end
  end

  def caveats
    <<~EOS
      For the system Java wrappers to find this JDK, symlink it with
        sudo ln -sfn #{opt_libexec}/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk
    EOS
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
