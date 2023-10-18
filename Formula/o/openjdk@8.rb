class OpenjdkAT8 < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://github.com/openjdk/jdk8u/archive/refs/tags/jdk8u382-ga.tar.gz"
  version "1.8.0-382"
  sha256 "a000ec82e594ccfe46ac1a4aa3d7399532aa53875042f22f16eae9367c4b20eb"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :stable
    regex(/^jdk(8u\d+)-ga$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.gsub("8u", "1.8.0+") }.compact
    end
  end

  bottle do
    sha256 cellar: :any,                 ventura:      "ace452ef3b9f4c56bde6ff41c6784e0f866661df99e17aabaf68d85bcc53b03a"
    sha256 cellar: :any,                 monterey:     "41202240ac3c899dea34407fd6678a4cc00426528371a8bcefe7660445599693"
    sha256 cellar: :any,                 big_sur:      "17fb977f50c91f0bd61ce995473dab0fdb954687f59ac7d27427186f06c622aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "db2a5e233fb3194a8eac218c137cd81dfb38dd6d7a1b6bf87568864cda195a15"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on arch: :x86_64
  depends_on "freetype"
  depends_on "giflib"

  uses_from_macos "cups"
  uses_from_macos "unzip"
  uses_from_macos "zip"

  on_monterey :or_newer do
    depends_on "gawk" => :build
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "fontconfig"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxrandr"
    depends_on "libxrender"
    depends_on "libxt"
    depends_on "libxtst"
  end

  # Oracle doesn't serve JDK 7 downloads anymore, so we use Zulu JDK 7 for bootstrapping.
  # https://www.azul.com/downloads/?version=java-7-lts&package=jdk
  resource "boot-jdk" do
    on_macos do
      url "https://cdn.azul.com/zulu/bin/zulu7.56.0.11-ca-jdk7.0.352-macosx_x64.tar.gz"
      sha256 "31909aa6233289f8f1d015586825587e95658ef59b632665e1e49fc33a2cdf06"
    end
    on_linux do
      url "https://cdn.azul.com/zulu/bin/zulu7.56.0.11-ca-jdk7.0.352-linux_x64.tar.gz"
      sha256 "8a7387c1ed151474301b6553c6046f865dc6c1e1890bcf106acc2780c55727c8"
    end
  end

  def install
    _, _, update = version.to_s.rpartition("-")
    boot_jdk = buildpath/"boot-jdk"
    resource("boot-jdk").stage boot_jdk
    java_options = ENV.delete("_JAVA_OPTIONS")

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
                "if test \"${XC_VERSION_PARTS[[0]]}\" != \"#{MacOS::Xcode.version.major}\""
    else
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
      --with-giflib=system
    ]

    ldflags = ["-Wl,-rpath,#{loader_path.gsub("$", "\\$$$$")}/server"]
    if OS.mac?
      args += %w[
        --with-toolchain-type=clang
        --with-zlib=system
      ]

      # Work around SDK issues with JavaVM framework.
      if MacOS.version <= :catalina
        sdk_path = MacOS::CLT.sdk_path(MacOS.version)
        ENV["SDKPATH"] = ENV["SDKROOT"] = sdk_path
        javavm_framework_path = sdk_path/"System/Library/Frameworks/JavaVM.framework/Frameworks"
        args += %W[
          --with-extra-cflags=-F#{javavm_framework_path}
          --with-extra-cxxflags=-F#{javavm_framework_path}
        ]
        ldflags << "-F#{javavm_framework_path}"
      end
    else
      args += %W[
        --with-toolchain-type=gcc
        --x-includes=#{HOMEBREW_PREFIX}/include
        --x-libraries=#{HOMEBREW_PREFIX}/lib
        --with-cups=#{HOMEBREW_PREFIX}
        --with-fontconfig=#{HOMEBREW_PREFIX}
        --with-stdc++lib=dynamic
      ]
      extra_rpath = rpath(source: libexec/"lib/amd64", target: libexec/"jre/lib/amd64")
      ldflags << "-Wl,-rpath,#{extra_rpath.gsub("$", "\\$$$$")}"
    end
    args << "--with-extra-ldflags=#{ldflags.join(" ")}"

    system "bash", "common/autoconf/autogen.sh"
    system "bash", "configure", *args

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
