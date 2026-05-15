class OpenjdkAT11 < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.org/"
  url "https://github.com/openjdk/jdk11u/archive/refs/tags/jdk-11.0.31-ga.tar.gz"
  sha256 "11c04910fb30a26a807b0847c9cccb8fc72e0b4d0e9db54e31957f27c7f03fd9"
  license "GPL-2.0-only"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^jdk[._-]v?(11(?:\.\d+)*)-ga$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f1d4cab805e34e540c02dc897e737c724b5e11b4f0f7234e7a2261d08362e77c"
    sha256 cellar: :any,                 arm64_sequoia: "2f4ae77b7d610cb674a6ed3e50a845045c1b7ec183a3880b2b06330a1c80ab19"
    sha256 cellar: :any,                 arm64_sonoma:  "f87d1fb5038ed73123d58a028989f66438d24d3d7f370bd58cf8ba1452f8a501"
    sha256 cellar: :any,                 sonoma:        "fe8f555eab63fa7044b97806a11dc0304991062edb4801a1899bee5d779bb132"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e207943cd73c41ca85642d8a71ef275a3066f311ecfa421cfcddbc73a3eef79e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1481b8b3267eb790b9cc7e7b8a2b2813f07b4e0aff6735230b8c0d4d0ee65a72"
  end

  keg_only :versioned_formula

  deprecate! date: "2023-09-30", because: :unmaintained
  disable! date: "2032-01-31", because: :unmaintained

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
    depends_on "zlib-ng-compat"
  end

  # ARM64: https://www.azul.com/downloads/?version=java-11-lts&package=jdk
  # Intel: https://jdk.java.net/archive/
  resource "boot-jdk" do
    on_macos do
      on_arm do
        url "https://cdn.azul.com/zulu/bin/zulu11.88.17-ca-jdk11.0.31-macosx_aarch64.tar.gz"
        sha256 "fe756215bc360cab0703c9c851f7e46d4762591dff33011420a710d4950e79b1"
      end
      on_intel do
        url "https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_osx-x64_bin.tar.gz"
        sha256 "f365750d4be6111be8a62feda24e265d97536712bc51783162982b8ad96a70ee"
      end
    end
    on_linux do
      on_arm do
        url "https://cdn.azul.com/zulu/bin/zulu11.88.17-ca-jdk11.0.31-linux_aarch64.tar.gz"
        sha256 "8fa22d2c45355b7db381f932f8cda60f959299e2836167d79f0ccb3b1465f0fb"
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
    boot_jdk /= "Contents/Home" if OS.mac?
    java_options = ENV.delete("_JAVA_OPTIONS")

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

    # Work around Xcode 16 bug: https://bugs.openjdk.org/browse/JDK-8340341
    if DevelopmentTools.clang_build_version == 1600
      args << "--with-extra-cflags=-mllvm -enable-constraint-elimination=0"
    end

    # Fix: prevent clang C++ driver from receiving `-std=gnu23` (Homebrew CI macOS + Linux toolchains)
    args << "--with-extra-cxxflags=-std=gnu++17"

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
        public static void main(String[] args) {
          System.out.println("Hello, world!");
        }
      }
    JAVA

    system bin/"javac", "HelloWorld.java"

    assert_match "Hello, world!", shell_output("#{bin}/java HelloWorld")
  end
end
