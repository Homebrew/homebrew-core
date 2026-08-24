class OpenjdkAT11 < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.org/"
  url "https://github.com/openjdk/jdk11u/archive/refs/tags/jdk-11.0.32.1-ga.tar.gz"
  sha256 "918a42d31544c5e7f70182c6ee76c95b1f042f914c375b814b64144cc8611adb"
  license "GPL-2.0-only"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^jdk[._-]v?(11(?:\.\d+)*)-ga$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b5ba74af74273f4135ed3b5474ec929dd41c7e6d573bbdbe398ac3c8ae8e11dc"
    sha256 cellar: :any, arm64_sequoia: "f11b64f7d65c682021c685666177692bbd0f60c24aca99143e678d4c281ce0da"
    sha256 cellar: :any, arm64_sonoma:  "14e45df7da45432b56bc0f89ac2c7447977389eb7999d1c2e5d2918cb8bedcc0"
    sha256 cellar: :any, sonoma:        "f89945555fcb8bdce60f23b9a66a9f0ba1bbf9e85d051f4d4c652077ee92b58f"
    sha256 cellar: :any, arm64_linux:   "a47fbdf47640b64dd1ca336706940ed5beb7d6adff241d369b246c9ff06c361c"
    sha256 cellar: :any, x86_64_linux:  "871aea10e596355fe739f92b37076df6fc2f71e0a3bfb936f48fa608448872a3"
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

  uses_from_macos "unzip" => :build
  uses_from_macos "zip" => :build
  uses_from_macos "cups" => :no_linkage

  on_linux do
    depends_on "libxt" => :build
    depends_on "alsa-lib"
    depends_on "fontconfig" => :no_linkage
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxi"
    depends_on "libxrandr" => :no_linkage
    depends_on "libxrender"
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
        --with-freetype-include=#{formula_opt_include("freetype")}
        --with-freetype-lib=#{formula_opt_lib("freetype")}
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
