class Openjdk < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://github.com/openjdk/jdk19u/archive/refs/tags/jdk-19.0.1-ga.tar.gz"
  sha256 "26ebf4d182a0d4bba7a0387a931af576a538745a98ef6eb2c70e22655e846a45"
  license "GPL-2.0-only" => { with: "Classpath-exception-2.0" }

  livecheck do
    url :stable
    regex(/^jdk[._-]v?(\d+(?:\.\d+)*)-ga$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "1948f03bd44e133b30b83319a930e653edac721e5550530564def773c7eb0f30"
    sha256 cellar: :any, arm64_monterey: "6d02a30983f979ac7bd32ff4001b50cd4afe8b10c4a566009dcee918a4114a05"
    sha256 cellar: :any, arm64_big_sur:  "b7beaa228901b28811563e24225f176571b2f960f50eea025761fcc2d1b96dca"
    sha256 cellar: :any, ventura:        "f63e517af005631b82432bcd15549d1291eb1d59e01b484332e3e880eb49690d"
    sha256 cellar: :any, monterey:       "7aa6e5b03157684305c3712718d95e487e258bfc9689a436e568510365086251"
    sha256 cellar: :any, big_sur:        "ff55a2d6082d2e440f55532ea332c45f192643ce3ac0a4dc3d4823b9515fdb7f"
    sha256 cellar: :any, catalina:       "242e5cf8253bdece0d4e9b5e3841ddf24b34c713b7ce96daa6b1bada7d4433fe"
    sha256               x86_64_linux:   "b040105b3f8e64514e9b87ab70ffbca01138860f571f3e6f53b6274748ebe063"
  end

  keg_only :shadowed_by_macos

  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build
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
    depends_on "freetype"
    depends_on "libx11"
    depends_on "libxext"
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
        url "https://download.java.net/java/GA/jdk18.0.2.1/db379da656dc47308e138f21b33976fa/1/GPL/openjdk-18.0.2.1_macos-aarch64_bin.tar.gz"
        sha256 "c05aec589f55517b8bedd01463deeba80f666da3fb193be024490c9d293097a8"
      end
      on_intel do
        url "https://download.java.net/java/GA/jdk18.0.2.1/db379da656dc47308e138f21b33976fa/1/GPL/openjdk-18.0.2.1_macos-x64_bin.tar.gz"
        sha256 "604ba4b3ccb594973a3a73779a367363c53dd91e5a9de743f4fbfae89798f93a"
      end
    end
    on_linux do
      on_arm do
        url "https://download.java.net/java/GA/jdk18.0.2.1/db379da656dc47308e138f21b33976fa/1/GPL/openjdk-18.0.2.1_linux-aarch64_bin.tar.gz"
        sha256 "79900237a5912045f8c9f1065b5204a474803cbbb4d075ab9620650fb75dfc1b"
      end
      on_intel do
        url "https://download.java.net/java/GA/jdk18.0.2.1/db379da656dc47308e138f21b33976fa/1/GPL/openjdk-18.0.2.1_linux-x64_bin.tar.gz"
        sha256 "3bfdb59fc38884672677cebca9a216902d87fe867563182ae8bc3373a65a2ebd"
      end
    end
  end

  # Fix build failure on Monterey with Clang 14+ due to function warning attribute.
  # Remove if backported to JDK 19.
  patch do
    url "https://github.com/openjdk/jdk/commit/0599a05f8c7e26d4acae0b2cc805a65bdd6c6f67.patch?full_index=1"
    sha256 "6a645cedccb54b4409f4226ba672b50687e18a3f5dfa0485ce1db6f5bc35f3d0"
  end

  # Patch to restore build on macOS 13
  patch :DATA

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

      %W[
        --enable-dtrace
        --with-sysroot=#{MacOS.sdk_path}
      ]
    else
      %W[
        --with-x=#{HOMEBREW_PREFIX}
        --with-cups=#{HOMEBREW_PREFIX}
        --with-fontconfig=#{HOMEBREW_PREFIX}
        --with-freetype=system
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

__END__
diff -pur a/src/jdk.net/macosx/native/libextnet/MacOSXSocketOptions.c b/src/jdk.net/macosx/native/libextnet/MacOSXSocketOptions.c
--- a/src/jdk.net/macosx/native/libextnet/MacOSXSocketOptions.c	2022-08-12 22:24:53.000000000 +0200
+++ b/src/jdk.net/macosx/native/libextnet/MacOSXSocketOptions.c	2022-10-24 18:27:36.000000000 +0200
@@ -29,9 +29,9 @@
 #include <unistd.h>
 
 #include <jni.h>
-#include <netinet/tcp.h>
 
 #define __APPLE_USE_RFC_3542
+#include <netinet/tcp.h>
 #include <netinet/in.h>
 
 #ifndef IP_DONTFRAG
