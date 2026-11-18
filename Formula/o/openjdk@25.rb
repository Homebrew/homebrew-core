class OpenjdkAT25 < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.org/"
  url "https://github.com/openjdk/jdk25u/archive/refs/tags/jdk-25.0.5.1-ga.tar.gz"
  sha256 "b4a28f325bc5f38f87c13489a5825613bba78a0e55ebe4202a993e982c62922e"
  license "GPL-2.0-only" => { with: "Classpath-exception-2.0" }
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^jdk[._-]v?(25(?:\.\d+)*)-ga$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "096cc4ebdba3dcb78f084bf1b2f462cac495d46cd60b6be4b4f8a7d35c6bddfe"
    sha256 cellar: :any, arm64_tahoe:       "35067910d9b2255378bc5919130f52c56fe387550ce32ca9f7ab035eaebc56b5"
    sha256 cellar: :any, arm64_sequoia:     "e48c1a92f9433bdf5fee5c604cd8d6b1a4a1c8aad32a1ac9a42597528d89354e"
    sha256               arm64_linux:       "5317a80f99ad65a5f418bc9c2eb3212d229215f54c3539bccec3c4382e082230"
    sha256               x86_64_linux:      "3c97667d02720e0dcb55fa053506259ab749f4f807431657754663340eb58685"
  end

  keg_only :versioned_formula

  deprecate! date: "2030-09-30", because: :unmaintained
  disable! date: "2033-09-30", because: :unmaintained

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

  on_macos do
    depends_on xcode: :build # for metal
  end

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

  # From https://jdk.java.net/archive/
  resource "boot-jdk" do
    on_macos do
      on_arm do
        url "https://download.java.net/java/GA/jdk25.0.2/b1e0dfa218384cb9959bdcb897162d4e/10/GPL/openjdk-25.0.2_macos-aarch64_bin.tar.gz"
        sha256 "7581b0d1752cd5acbf39e286c03f07b6cd6c205b562eb2fe753ff0253cf4c1bf"
      end
      on_intel do
        url "https://download.java.net/java/GA/jdk25.0.2/b1e0dfa218384cb9959bdcb897162d4e/10/GPL/openjdk-25.0.2_macos-x64_bin.tar.gz"
        sha256 "4ec2f4bc47b057fdf9cda07af27fae8f3605e90fa963d4240d63baeb46ede460"
      end
    end
    on_linux do
      on_arm do
        url "https://download.java.net/java/GA/jdk25.0.2/b1e0dfa218384cb9959bdcb897162d4e/10/GPL/openjdk-25.0.2_linux-aarch64_bin.tar.gz"
        sha256 "671208d205e70c9805da45a483f670d49dd64654990a7b7223ccffb2abb070dd"
      end
      on_intel do
        url "https://download.java.net/java/GA/jdk25.0.2/b1e0dfa218384cb9959bdcb897162d4e/10/GPL/openjdk-25.0.2_linux-x64_bin.tar.gz"
        sha256 "555ce0821e4fe175ea50d54518cd6fbece9663c1998de529bc6ce429534457df"
      end
    end
  end

  def install
    boot_jdk = buildpath/"boot-jdk"
    resource("boot-jdk").stage boot_jdk
    boot_jdk /= "Contents/Home" if OS.mac?
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
      --with-freetype=system
      --with-giflib=system
      --with-harfbuzz=system
      --with-lcms=system
      --with-libjpeg=system
      --with-libpng=system
      --with-zlib=system
    ]

    ldflags = %W[
      -Wl,-rpath,#{loader_path.gsub("$", "\\$$")}
      -Wl,-rpath,#{loader_path.gsub("$", "\\$$")}/server
    ]
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

    system "bash", "configure", *args

    ENV["MAKEFLAGS"] = "JOBS=#{ENV.make_jobs}"
    system "make", "images"

    jdk = libexec
    if OS.mac?
      libexec.install Dir["build/*/images/jdk-bundle/*"].first => "openjdk.jdk"
      jdk /= "openjdk.jdk/Contents/Home"
    else
      libexec.install Dir["build/linux-*-server-release/images/jdk/*"]
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
          sudo ln -sfn #{opt_libexec}/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-25.jdk
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
