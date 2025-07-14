class Openjdk < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://github.com/openjdk/jdk24u/archive/refs/tags/jdk-24.0.1-ga.tar.gz"
  sha256 "2ccaaf7c5f03b6f689347df99e6e34cd6d3b30bc56af815c8c152a6eeb6a6c25"
  license "GPL-2.0-only" => { with: "Classpath-exception-2.0" }

  livecheck do
    url :stable
    regex(/^jdk[._-]v?(\d+(?:\.\d+)*)-ga$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "f75d5d24e460d26c1cdc01b60d9a523c9913ebc3b738931db4a18f051dd291a3"
    sha256 cellar: :any, arm64_sonoma:  "f38043248a4160c4fd1c4090e4f77083a892a58c4ee94776807f711f4a784458"
    sha256 cellar: :any, arm64_ventura: "18e5a1046b1c05b9336598bb9408659f694baf12e2de8059c99b35228e705e9b"
    sha256 cellar: :any, sonoma:        "f8c4ede8652ac9f1d66b12b9f20462f54eb377b015dd5d1849e945d2364a534f"
    sha256 cellar: :any, ventura:       "96d0d0908e1bcd114aa685287685eda27b253d9a4176963cbda84279da24b906"
    sha256               arm64_linux:   "d50b7447042596d2a6e252bb16bfefb48862d777a25c095aedbb360cf96194a7"
    sha256               x86_64_linux:  "649d2e733181bb670bb63098a912a9e24a55fcd697c30eb7738fa06db31f9cdd"
  end

  keg_only :shadowed_by_macos

  depends_on "autoconf" => :build
  depends_on "pkgconf" => :build
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

  # From https://jdk.java.net/archive/
  resource "boot-jdk" do
    on_macos do
      on_arm do
        url "https://download.java.net/java/GA/jdk23.0.2/6da2a6609d6e406f85c491fcb119101b/7/GPL/openjdk-23.0.2_macos-aarch64_bin.tar.gz"
        sha256 "bff699bb27455c2bb51d6e8f2467b77a4833388412aa2d95ec1970ddfb0e7b6c"
      end
      on_intel do
        url "https://download.java.net/java/GA/jdk23.0.2/6da2a6609d6e406f85c491fcb119101b/7/GPL/openjdk-23.0.2_macos-x64_bin.tar.gz"
        sha256 "b4cc7d7b51520e99308e1b4d3f8467790072c42319b9d3838ec8cfd4f69f0bc1"
      end
    end
    on_linux do
      on_arm do
        url "https://download.java.net/java/GA/jdk23.0.2/6da2a6609d6e406f85c491fcb119101b/7/GPL/openjdk-23.0.2_linux-aarch64_bin.tar.gz"
        sha256 "8e9b2c7e0f138de785dc754ad1dfa067671de66672b5e84bb7f6f6c219a6b02b"
      end
      on_intel do
        url "https://download.java.net/java/GA/jdk23.0.2/6da2a6609d6e406f85c491fcb119101b/7/GPL/openjdk-23.0.2_linux-x64_bin.tar.gz"
        sha256 "017f4ed8e8234d85e5bc1e490bb86f23599eadb6cfc9937ee87007b977a7d762"
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

    # Workaround for Xcode 16 bug: https://bugs.openjdk.org/browse/JDK-8340341.
    if DevelopmentTools.clang_build_version == 1600
      args << "--with-extra-cflags=-mllvm -enable-constraint-elimination=0"
    end

    # Temporary workaround for the "sed: RE error: illegal byte sequence" issue on macOS 15 and later (on_arm).
    # See https://bugs.openjdk.org/browse/JDK-8353948 for more details.
    # Could be removed in openjdk@25, though it might be resolved earlier if plans change.
    # References:
    # - Related bug: https://bugs.openjdk.org/browse/JDK-8354449
    # - Upstream PR: https://github.com/openjdk/jdk/pull/24601
    if OS.mac? && MacOS.version >= :sequoia && Hardware::CPU.arm?
      (buildpath/"src/java.xml.crypto/share/classes" /
        "com/sun/org/apache/xml/internal/security/resource" /
        "xmlsecurity_de.properties").unlink
    end

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
