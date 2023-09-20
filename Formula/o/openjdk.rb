class Openjdk < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://github.com/openjdk/jdk21u/archive/refs/tags/jdk-21-ga.tar.gz"
  version "21"
  sha256 "46493827f8dcf341cbd70c5febdf0d83d3c6c14e33fcb3e543da6e25a7ce3fdc"
  license "GPL-2.0-only" => { with: "Classpath-exception-2.0" }

  livecheck do
    url :stable
    regex(/^jdk[._-]v?(\d+(?:\.\d+)*)-ga$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "87ee921ad11db76e5fbe7fba697f3d4ff8d8a0a170f1ccf0f8f1a484bd3235de"
    sha256 cellar: :any, arm64_ventura:  "7c023f8b5172370350f8eef5a5363f5225be4d75003cfe1ef25e729aa474a4dc"
    sha256 cellar: :any, arm64_monterey: "563bd49837bbdb636c072bfe81257d825b0a418dbfe120bef5b3ed6ea88345e5"
    sha256 cellar: :any, arm64_big_sur:  "56de3d53e9b83b4731d8decc25087ba5df3c513ba8728759dfb776ec2ab8fb1a"
    sha256 cellar: :any, sonoma:         "79b769226997081c25b175582e654aeac9230c141e0d54891425dc9faab12714"
    sha256 cellar: :any, ventura:        "00801f056fbce3480637acdf48b4aaffd977e38450f83b72c2954b48c329153b"
    sha256 cellar: :any, monterey:       "214cffc504d48ca3e369ec32b7c75e3bf3795d819ea8939cbe2b380f003cf924"
    sha256 cellar: :any, big_sur:        "f9f580b472e91bdc818df43c7384088b6235ce6b900850d5a7b962a52869b4a0"
    sha256               x86_64_linux:   "1db7667c3af7a5c4cee3ebe058b620f908afa23eb3a646f7b1a96a8254386d69"
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
        url "https://download.java.net/java/GA/jdk20.0.2/6e380f22cbe7469fa75fb448bd903d8e/9/GPL/openjdk-20.0.2_macos-aarch64_bin.tar.gz"
        sha256 "2e6522bb574f76cd3f81156acd59115a014bf452bbe4107f0d31ff9b41b3da57"
      end
      on_intel do
        url "https://download.java.net/java/GA/jdk20.0.2/6e380f22cbe7469fa75fb448bd903d8e/9/GPL/openjdk-20.0.2_macos-x64_bin.tar.gz"
        sha256 "c65ba92b73d8076e2a10029a0674d40ce45c3e0183a8063dd51281e92c9f43fc"
      end
    end
    on_linux do
      on_arm do
        url "https://download.java.net/java/GA/jdk20.0.2/6e380f22cbe7469fa75fb448bd903d8e/9/GPL/openjdk-20.0.2_linux-aarch64_bin.tar.gz"
        sha256 "3238c93267c663dbca00f5d5b0e3fbba40e1eea2b4281612f40542d208b6dd9a"
      end
      on_intel do
        url "https://download.java.net/java/GA/jdk20.0.2/6e380f22cbe7469fa75fb448bd903d8e/9/GPL/openjdk-20.0.2_linux-x64_bin.tar.gz"
        sha256 "beaf61959c2953310595e1162b0c626aef33d58628771033ff2936609661956c"
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
