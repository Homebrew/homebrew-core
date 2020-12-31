class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/videolan/libbluray/1.2.1/libbluray-1.2.1.tar.bz2"
  sha256 "5223e83f7988ea2cc860b5cadcaf9cf971087b0c80ca7b60cc17c8300cae36ec"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.videolan.org/pub/videolan/libbluray/"
    regex(%r{>([\d.]+)/<}i)
  end

  bottle do
    cellar :any
    sha256 "38bc062c7702c8ebefcc571bd2184c7ab91fa37b40af906ea1ef073fb9048b56" => :big_sur
    sha256 "829e85f1a3c7ddce0c377fcfc4ebe0cebd5dc64d3ef29421ff1dbc8b5d50738a" => :catalina
    sha256 "0258d74ee2371c29c389d619a412661eeb1fc29b4f284d707d90b68ddb0b798b" => :mojave
    sha256 "b610d2d4065288546df4b6ce56a709fce3f542e67118b3fac84d649a035491eb" => :high_sierra
  end

  head do
    url "https://code.videolan.org/videolan/libbluray.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"

  uses_from_macos "libxml2"

  def install
    args = %W[--prefix=#{prefix} --disable-dependency-tracking --disable-silent-rules --disable-bdjava-jar]

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
