class Openjdk < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://github.com/openjdk/jdk19u/archive/refs/tags/jdk-19.0.2-ga.tar.gz"
  sha256 "c297c9d0a09721e84c420e7893ff9ba2e0c4e27370507dec4b356b59e6c8e7a2"
  license "GPL-2.0-only" => { with: "Classpath-exception-2.0" }

  livecheck do
    url :stable
    regex(/^jdk[._-]v?(\d+(?:\.\d+)*)-ga$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "c576dc5ee012c98010595cecfd9373050e9a48000291201c9f057cb0fa7eaf43"
    sha256 cellar: :any, arm64_monterey: "f0d33cdc95ee66471146865dd98092c92b0ef97598fe1ea57d4cb31f859851b5"
    sha256 cellar: :any, arm64_big_sur:  "05f317a736e6d6e2d4d20cc39cabbc69708d45b77ead5767ed082a3ead23aa89"
    sha256 cellar: :any, ventura:        "de86351713f22cf37148d2def9002e8126a60d2f37540da28ea7c6a0edb8ff46"
    sha256 cellar: :any, monterey:       "77f0d28cc4f5c8bd5907b5080fd760930326f1b12e7afbf2361b2527f960d6e9"
    sha256 cellar: :any, big_sur:        "826d60202fa869103d4b35312555da0ccee5247f3875423836cc70ef93b46cd0"
    sha256               x86_64_linux:   "46f18654dc8f56ea1a5b2d17e973d76faf517f394758c79b6e87a0b2ecaada6a"
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
