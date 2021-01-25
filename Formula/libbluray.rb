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
    rebuild 1
    sha256 "ddc9740b0ec3c919e709f163b694c3c00ad36a5c6f7ed9db244e08c73d12f7a4" => :big_sur
    sha256 "fecb563ca1eefe2b784bec27c64b8bbe65850a8b483d12cee8123b3f9ff940de" => :arm64_big_sur
    sha256 "8d2dbe765f837608676970568fe081ba91c12af436c2812c2224e4a878692e86" => :catalina
    sha256 "cad2684af7571e916f43c0945324a2024de313f49e67829434f61ee413e02bb7" => :mojave
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
