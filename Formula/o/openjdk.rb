class Openjdk < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://github.com/openjdk/jdk23u/archive/refs/tags/jdk-23-ga.tar.gz"
  sha256 "02e2c3b356c00c3cc7efcca2fbd37723f55349677a1de483a9be8a43f327de76"
  license "GPL-2.0-only" => { with: "Classpath-exception-2.0" }

  livecheck do
    url :stable
    regex(/^jdk[._-]v?(\d+(?:\.\d+)*)-ga$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "ababf9f922e2c91039ac07209e7e66ee1d5e55f7cbadae25597ce2d1324e328f"
    sha256 cellar: :any, arm64_sonoma:  "0ba02cbe94e2fc2b1aec69f0e9a624cc8944055170f1b7ca4241ad4fc3b3ac7c"
    sha256 cellar: :any, arm64_ventura: "e4d1c93665666a4b66b8b47d381e0ce2e1a7d3d615f20739ae216f92cd8d64e5"
    sha256 cellar: :any, sonoma:        "caaf8ccee728ec17e0ceb124433c8a627084446c79a1041baf8908b8fd5c78a0"
    sha256 cellar: :any, ventura:       "e2804a8040a8fd46fed466f103391f314be906e64d5c349963ee81cdd8e13742"
    sha256               x86_64_linux:  "82fc99187027bf29857ea070a092b41ce76169bbedad8a91177c60f1d405829d"
  end

  keg_only :shadowed_by_macos

  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build # for metal
  depends_on "freetype"
  depends_on "giflib"
  depends_on "harfbuzz"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "little-cms2"
  depends_on macos: :catalina

  uses_from_macos "cups"
  uses_from_macos "unzip"
  uses_from_macos "zip"
  uses_from_macos "zlib"

  on_macos do
    if DevelopmentTools.clang_build_version == 1600
      depends_on "llvm" => :build

      fails_with :clang do
        cause <<~EOS
          Exception in thread "main" java.lang.ClassFormatError: StackMapTable format error: bad verification type
            at jdk.compiler/com.sun.tools.javac.Main.compile(Main.java:64)
            at jdk.compiler/com.sun.tools.javac.Main.main(Main.java:52)
        EOS
      end
    end
  end

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

  fails_with gcc: "5"

  # From https://jdk.java.net/archive/
  resource "boot-jdk" do
    on_macos do
      on_arm do
        url "https://download.java.net/java/GA/jdk22.0.2/c9ecb94cd31b495da20a27d4581645e8/9/GPL/openjdk-22.0.2_macos-aarch64_bin.tar.gz"
        sha256 "3dab98730234e1a87aec14bcb8171d2cae101e96ff4eed1dab96abbb08e843fd"
      end
      on_intel do
        url "https://download.java.net/java/GA/jdk22.0.2/c9ecb94cd31b495da20a27d4581645e8/9/GPL/openjdk-22.0.2_macos-x64_bin.tar.gz"
        sha256 "e8b3ec7a7077711223d31156e771f11723cd7af31c2017f1bd2eda20855940fb"
      end
    end
    on_linux do
      on_arm do
        url "https://download.java.net/java/GA/jdk22.0.2/c9ecb94cd31b495da20a27d4581645e8/9/GPL/openjdk-22.0.2_linux-aarch64_bin.tar.gz"
        sha256 "25fba2bd5585e1e9923134dc827f2bd5a2beaca3d242ae00b7e68c152faf7ba6"
      end
      on_intel do
        url "https://download.java.net/java/GA/jdk22.0.2/c9ecb94cd31b495da20a27d4581645e8/9/GPL/openjdk-22.0.2_linux-x64_bin.tar.gz"
        sha256 "41536f115668308ecf4eba92aaf6acaeb0936225828b741efd83b6173ba82963"
      end
    end
  end

  # Fix build with `--with-harfbuzz=system`.
  # https://github.com/openjdk/jdk/pull/19739
  patch do
    url "https://github.com/openjdk/jdk/commit/ba5a4670b8ad86fefb41a939752754bf36aac9dc.patch?full_index=1"
    sha256 "ff6c66f3fa81bef3fb18e88196c520cfa867aa5d57ebf26574635723b4d06d16"
  end

  def install
    if DevelopmentTools.clang_build_version == 1600
      ENV.llvm_clang
      ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    end

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
          sudo ln -sfn #{opt_libexec}/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
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
