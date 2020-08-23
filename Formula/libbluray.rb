class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/videolan/libbluray/1.2.0/libbluray-1.2.0.tar.bz2"
  sha256 "cd41ea06fd2512a77ebf63872873641908ef81ce2fe4e4c842f6035a47696c11"
  license "LGPL-2.1"

  bottle do
    cellar :any
    sha256 "ed5b295ee0b40b5c36ca2ceb289c106007f8fe9d475727288b61ea4dd5315bde" => :catalina
    sha256 "bde7b947d717e7da2367bb3b38ab79eab3843cf3c109603d7fb0c84993872164" => :mojave
    sha256 "a8a20bb4274ca8844ee7dc9ef27df6660dfe9cc180f85bbaebe11f1cc4edd053" => :high_sierra
  end

  head do
    url "https://code.videolan.org/videolan/libbluray.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "ant" => :build
  depends_on java: ["1.8", :build]
  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"

  uses_from_macos "libxml2"

  def install
    # Need to set JAVA_HOME manually since ant overrides 1.8 with 1.8+
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.safe_popen_read(cmd).chomp

    # https://mailman.videolan.org/pipermail/libbluray-devel/2014-April/001401.html
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"

    # Work around Xcode 11 clang bug
    # https://code.videolan.org/videolan/libbluray/issues/20
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

    args = %W[--prefix=#{prefix} --disable-dependency-tracking]

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libbluray/bluray.h>
      int main(void) {
        BLURAY *bluray = bd_init();
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lbluray", "-o", "test"
    system "./test"
  end
end
