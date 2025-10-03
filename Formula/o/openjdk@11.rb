class OpenjdkAT11 < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.org/"
  url "https://github.com/openjdk/jdk11u/archive/refs/tags/jdk-11.0.28-ga.tar.gz"
  sha256 "c051b84b55a826ff90ac601ff7501449fb6a578a89357bbc7550990a78bb5f1b"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^jdk[._-]v?(11(?:\.\d+)*)-ga$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0c7019b81053e9b5a1bb519d3edea232426400749dec1be74f7cfb85edeb38a0"
    sha256 cellar: :any,                 arm64_sequoia: "c2f2b74da21a9062e4b288dedc5a0041814addbde1829b3113ef2d68e82821cc"
    sha256 cellar: :any,                 arm64_sonoma:  "cadeb8b67fddfad5831b43590417fd0bc0b259c03baf162bdfc13dd99aa4a7ca"
    sha256 cellar: :any,                 arm64_ventura: "d66cfeeac9d98b5f4868187eaf49753e5db88d416bdf39faa5357e29bb175367"
    sha256 cellar: :any,                 sonoma:        "2e7f751a1f1ab3ccef7247e74d6c1f274a861d36c0b6e9df58f57a249eda4b6a"
    sha256 cellar: :any,                 ventura:       "7249281922ef7324fac986eb4091ae1a38c3c1f3fba5438195b0c976ef675887"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d92efb4e4a7b77fe628ae75e2b01def4457110662e169a6dbcd90809e8c2992"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "422052b9e3633328435bb97e0ce20a001a1f9eea233f0f6bb7d9545b583b80b4"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "harfbuzz"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "little-cms2"

  uses_from_macos "cups"
  uses_from_macos "unzip"
  uses_from_macos "zip"
  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
    depends_on "fontconfig"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxi"
    depends_on "libxrandr"
    depends_on "libxrender"
    depends_on "libxt"
    depends_on "libxtst"
  end

  # ARM64: https://www.azul.com/downloads/?version=java-11-lts&package=jdk
  # Intel: https://jdk.java.net/archive/
  resource "boot-jdk" do
    on_macos do
      on_arm do
        url "https://cdn.azul.com/zulu/bin/zulu11.68.17-ca-jdk11.0.21-macosx_aarch64.tar.gz"
        sha256 "f7b7d10d42b75f9ac8e7311732d039faee2ce854b9ad462e0936e6c88d01a19f"
      end
      on_intel do
        url "https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_osx-x64_bin.tar.gz"
        sha256 "f365750d4be6111be8a62feda24e265d97536712bc51783162982b8ad96a70ee"
      end
    end
    on_linux do
      on_arm do
        url "https://cdn.azul.com/zulu/bin/zulu11.68.17-ca-jdk11.0.21-linux_aarch64.tar.gz"
        sha256 "5638887df0e680c890b4c6f9543c9b61c96c90fb01f877d79ae57566466d3b3d"
      end
      on_intel do
        url "https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz"
        sha256 "99be79935354f5c0df1ad293620ea36d13f48ec3ea870c838f20c504c9668b57"
      end
    end
  end

  def install
    boot_jdk = buildpath/"boot-jdk"
    resource("boot-jdk").stage boot_jdk
    boot_jdk /= "Contents/Home" if OS.mac? && !Hardware::CPU.arm?
    java_options = ENV.delete("_JAVA_OPTIONS")

    # Fix pack200 failure only when building with newer Clang
    if OS.mac? && DevelopmentTools.clang_build_version >= 1600
      inreplace "src/jdk.pack/share/native/common-unpack/constants.h",
                "(-1)<<13",
                "static_cast<int32_t>(~0u << 13)"
    end

    args = %W[
      --disable-hotspot-gtest
      --disable-warnings-as-errors
      --with-boot-jdk-jvmargs=#{java_options}
      --with-boot-jdk=#{boot_jdk}
      --with-debug-level=release
      --with-conf-name=release
      --with-jvm-variants=server
      --with-jvm-features=shenandoahgc
      --with-native-debug-symbols=none
      --with-vendor-bug-url=#{tap.issues_url}
      --with-vendor-name=#{tap.user}
      --with-vendor-url=#{tap.issues_url}
      --with-vendor-version-string=#{tap.user}
      --with-vendor-vm-bug-url=#{tap.issues_url}
      --without-version-opt
      --without-version-pre
      --with-freetype=system
      --with-giflib=system
      --with-harfbuzz=system
      --with-lcms=system
      --with-libjpeg=system
      --with-libpng=system
      --with-zlib=system
    ]

    ldflags = ["-Wl,-rpath,#{loader_path.gsub("$", "\\$$")}/server"]
    args += if OS.mac?
      ldflags << "-headerpad_max_install_names"

      # Allow unbundling `freetype` on macOS
      inreplace "make/autoconf/lib-freetype.m4", '= "xmacosx"', '= ""'

      %W[
        --enable-dtrace
        --with-freetype-include=#{Formula["freetype"].opt_include}
        --with-freetype-lib=#{Formula["freetype"].opt_lib}
        --with-sysroot=#{MacOS.sdk_path}
      ]
    else
      %W[
        --with-x=#{HOMEBREW_PREFIX}
        --with-cups=#{HOMEBREW_PREFIX}
        --with-fontconfig=#{HOMEBREW_PREFIX}
        --with-stdc++lib=dynamic
      ]
    end
    args << "--with-extra-ldflags=#{ldflags.join(" ")}"

    if DevelopmentTools.clang_build_version == 1600
      args << "--with-extra-cflags=-mllvm -enable-constraint-elimination=0"
    end

    system "bash", "configure", *args

    ENV["MAKEFLAGS"] = "JOBS=#{ENV.make_jobs}"
    system "make", "images", "CONF=release"

    jdk = libexec
    if OS.mac?
      libexec.install Dir["build/release/images/jdk-bundle/*"].first => "openjdk.jdk"
      jdk /= "openjdk.jdk/Contents/Home"
    else
      libexec.install Dir["build/release/images/jdk/*"]
    end

    bin.install_symlink Dir[jdk/"bin/*"]
    include.install_symlink Dir[jdk/"include/*.h"]
    include.install_symlink Dir[jdk/"include"/OS.kernel_name.downcase/"*.h"]
    man1.install_symlink Dir[jdk/"man/man1/*"]
  end

  def caveats
    on_macos do
      <<~EOS
        For the system Java wrappers to find this JDK, symlink it with
          sudo ln -sfn #{opt_libexec}/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk
      EOS
    end
  end

  test do
    (testpath/"HelloWorld.java").write <<~JAVA
      class HelloWorld {
        public static void main(String args[]) {
          System.out.println("Hello, world!");
        }
      }
    JAVA

    system bin/"javac", "HelloWorld.java"

    assert_match "Hello, world!", shell_output("#{bin}/java HelloWorld")
  end
end
