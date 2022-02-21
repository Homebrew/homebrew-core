class OpenjdkAT8 < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://openjdk-sources.osci.io/openjdk8/openjdk8u322-ga.tar.xz"
  version "1.8.0+322"
  sha256 "e1ce7fc5def4446ca62df355f70548b2deb53fdcad548b0b3550ceaa96395247"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 monterey:     "d6904e2576f8876bae57288f6655686799506763ff49eb0939082c404f84dd02"
    sha256 cellar: :any,                 big_sur:      "5bcb2cbf4502f83cb2bfa439c8b838cc6573a39bd1c230cd51b076ba40d3198d"
    sha256 cellar: :any,                 catalina:     "3aef1fb4ca615ab2700103502213b4346f1867a95d34a2981689d8bba81faedc"
    sha256 cellar: :any,                 mojave:       "8f036a79d42e0ea7719ba6cad997cf6aec791c163bef744a929375a2e9c69779"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fe6095f8af1e870dc2bcc2888cf74a92985431bb4210df9214bcdc991161408a"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "gawk" => :build if MacOS.version > :big_sur
  depends_on "pkg-config" => :build
  depends_on "freetype"

  on_linux do
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

    ignore_missing_libraries %w[libjvm.so libawt_xawt.so]
  end

  # Oracle doesn't serve JDK 7 downloads anymore, so use Zulu JDK 7 for bootstrapping.
  resource "boot-jdk" do
    on_macos do
      url "https://cdn.azul.com/zulu/bin/zulu7.50.0.11-ca-jdk7.0.322-macosx_x64.tar.gz"
      sha256 "085af056bfa3cbba63992a388c4eadebb1e3ae6f88822bee17520488592d7726"
    end
    on_linux do
      url "https://cdn.azul.com/zulu/bin/zulu7.50.0.11-ca-jdk7.0.322-linux_x64.tar.gz"
      sha256 "68ac226429904f208a9b873898d2aa6fce3c900c4da8304d589d0b753634bb10"
    end
  end

  def install
    _, _, update = version.to_s.rpartition("+")
    java_options = ENV.delete("_JAVA_OPTIONS")

    boot_jdk = buildpath/"boot-jdk"
    resource("boot-jdk").stage(boot_jdk)

    # Work around clashing -I/usr/include and -isystem headers,
    # as superenv already handles this detail for us.
    inreplace "common/autoconf/flags.m4",
              '-isysroot \"$SYSROOT\"', ""
    inreplace "common/autoconf/toolchain.m4",
              '-isysroot \"$SDKPATH\" -iframework\"$SDKPATH/System/Library/Frameworks\"', ""
    inreplace "hotspot/make/bsd/makefiles/saproc.make",
              '-isysroot "$(SDKPATH)" -iframework"$(SDKPATH)/System/Library/Frameworks"', ""

    if OS.mac?
      # Fix macOS version detection. After 10.10 this was changed to a 6 digit number,
      # but this Makefile was written in the era of 4 digit numbers.
      inreplace "hotspot/make/bsd/makefiles/gcc.make" do |s|
        s.gsub! "$(subst .,,$(MACOSX_VERSION_MIN))", ENV["HOMEBREW_MACOS_VERSION_NUMERIC"]
        s.gsub! "MACOSX_VERSION_MIN=10.7.0", "MACOSX_VERSION_MIN=#{MacOS.version}"
      end

      # Fix Xcode 13 detection.
      inreplace "common/autoconf/toolchain.m4",
                "if test \"${XC_VERSION_PARTS[[0]]}\" != \"6\"",
                "if test \"${XC_VERSION_PARTS[[0]]}\" != \"13\""
    end

    if OS.linux?
      # Fix linker errors on brewed GCC
      inreplace "common/autoconf/flags.m4", "-Xlinker -O1", ""
      inreplace "hotspot/make/linux/makefiles/gcc.make", "-Xlinker -O1", ""
    end

    args = %W[
      --with-boot-jdk-jvmargs=#{java_options}
      --with-boot-jdk=#{boot_jdk}
      --with-debug-level=release
      --with-conf-name=release
      --with-jvm-variants=server
      --with-milestone=fcs
      --with-native-debug-symbols=none
      --with-update-version=#{update}
      --with-vendor-bug-url=#{tap.issues_url}
      --with-vendor-name=#{tap.user}
      --with-vendor-url=#{tap.issues_url}
      --with-vendor-vm-bug-url=#{tap.issues_url}
    ]

    if OS.mac?
      args << "--with-toolchain-type=clang"

      # Work around SDK issues with JavaVM framework.
      if MacOS.version <= :catalina
        sdk_path = MacOS::CLT.sdk_path(MacOS.version)
        ENV["SDKPATH"] = ENV["SDKROOT"] = sdk_path
        javavm_framework_path = sdk_path/"System/Library/Frameworks/JavaVM.framework/Frameworks"
        args += %W[--with-extra-cflags=-F#{javavm_framework_path}
                   --with-extra-cxxflags=-F#{javavm_framework_path}
                   --with-extra-ldflags=-F#{javavm_framework_path}]
      end
    else
      args += %W[--with-toolchain-type=gcc
                 --x-includes=#{HOMEBREW_PREFIX}/include
                 --x-libraries=#{HOMEBREW_PREFIX}/lib
                 --with-cups=#{HOMEBREW_PREFIX}
                 --with-fontconfig=#{HOMEBREW_PREFIX}]
    end

    chmod 0755, %w[configure common/autoconf/autogen.sh]

    system "common/autoconf/autogen.sh"
    system "./configure", *args

    ENV["MAKEFLAGS"] = "JOBS=#{ENV.make_jobs}"
    system "make", "bootcycle-images", "CONF=release"

    cd "build/release/images" do
      jdk = libexec

      if OS.mac?
        libexec.install Dir["j2sdk-bundle/*"].first => "openjdk.jdk"
        jdk /= "openjdk.jdk/Contents/Home"
      else
        libexec.install Dir["j2sdk-image/*"]
      end

      bin.install_symlink Dir[jdk/"bin/*"]
      include.install_symlink Dir[jdk/"include/*.h"]
      include.install_symlink Dir[jdk/"include/*/*.h"]
      man1.install_symlink Dir[jdk/"man/man1/*"]
    end
  end

  def caveats
    on_macos do
      <<~EOS
        For the system Java wrappers to find this JDK, symlink it with
          sudo ln -sfn #{opt_libexec}/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-8.jdk
      EOS
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
