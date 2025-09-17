class Openjdk < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.org/"
  url "https://github.com/openjdk/jdk24u/archive/refs/tags/jdk-24.0.2-ga.tar.gz"
  sha256 "d5a1b364de4335d86590d2e91eb8fce0560ade28759734c531915b8293e502e8"
  license "GPL-2.0-only" => { with: "Classpath-exception-2.0" }

  livecheck do
    url :stable
    regex(/^jdk[._-]v?(\d+(?:\.\d+)*)-ga$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3264bbfe9ce08bdcaaef8698961ddcb3ee163fa38cf1a13eeca736c9af4fa9e7"
    sha256 cellar: :any, arm64_sequoia: "8bf81e5d8275e7f3254ea8763d35c31817493acd1aab32c2325cbf1bf24d9176"
    sha256 cellar: :any, arm64_sonoma:  "53b07864628ca14780510d3b0e45e4e508c249730d303ae088fc011692cd556c"
    sha256 cellar: :any, arm64_ventura: "7fbdfb2880f604f5b13e1fcee174c6b6492f8eddffbdc154bd9f6a769f686219"
    sha256 cellar: :any, sonoma:        "e85b2b4420e2712200e13241cd90df9a2117682fb81aac422812310d42b403cc"
    sha256 cellar: :any, ventura:       "1ba92e820302e56e7f9c6957ac9dca4dc42be95550d49836287353998f843484"
    sha256               arm64_linux:   "95971b5825bf1982a8c7c9b22b17834fdd8cd12e4af31ba0fa98b88137398bbe"
    sha256               x86_64_linux:  "b4ef478b28eaf1ea4670e286161417a2eb0cc89cc75b6ce06f0d7dbe481ab620"
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

    # Remove the offending ISO-8859-1 resource (JDK-8354449)
    # upstream pr ref, https://github.com/openjdk/jdk24u/pull/220
    rm "src/java.xml.crypto/share/classes/com/sun/org/apache/xml/internal/security/resource/xmlsecurity_de.properties"
    odie "Remove the above resource patch" if build.stable? && version.major > "24"

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
