class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage "https://github.com/libass/libass"
  url "https://github.com/libass/libass/releases/download/0.13.3/libass-0.13.3.tar.gz"
  sha256 "86c8c45d14e4fd23b5aa45c72d9366c46b4e28087da306e04d52252e04a87d0a"

  bottle do
    cellar :any
    sha256 "382ac2942a012bf63beced7ad334f8f8bdcb05ac0f673d8b6b7e65e703dd4e79" => :sierra
    sha256 "8eedaec98988b02e79e615f7a7e3550f880e2fbd42af5fcb4bba6613e235e970" => :el_capitan
    sha256 "5455db85e4b0476b9590ddbe1fb6934fa7755efb2c925e35c87d30f17854fcbf" => :yosemite
  end

  head do
    url "https://github.com/libass/libass.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-fontconfig", "Disable CoreText backend in favor of the more traditional fontconfig"

  depends_on "pkg-config" => :build
  depends_on "yasm" => :build

  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz" => :recommended
  depends_on "fontconfig" => :optional

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--disable-coretext" if build.with? "fontconfig"

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include "ass/ass.h"
      int main() {
        ASS_Library *library;
        ASS_Renderer *renderer;
        library = ass_library_init();
        if (library) {
          renderer = ass_renderer_init(library);
          if (renderer) {
            ass_renderer_done(renderer);
            ass_library_done(library);
            return 0;
          }
          else {
            ass_library_done(library);
            return 1;
          }
        }
        else {
          return 1;
        }
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lass", "-o", "test"
    system "./test"
  end
end
