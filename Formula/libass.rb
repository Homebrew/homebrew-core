class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage "https://github.com/libass/libass"
  url "https://github.com/libass/libass/releases/download/0.13.7/libass-0.13.7.tar.gz"
  sha256 "008a05a4ed341483d8399c8071d57a39853cf025412b32da277e76ad8226e158"

  bottle do
    cellar :any
    sha256 "21f04f3347abcb82c3d0710bbe47a8e1e61943f38d15f361d5165a92632fee93" => :sierra
    sha256 "cb6084560a8a866727c0957bd327ab575bf6e7ea906ccc0693946a2d18b5bca7" => :el_capitan
    sha256 "e5a92d4cbc9ff8ca1bfac7862dd0f7926417155a8afb9e3b2ff9376b96dce9e9" => :yosemite
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
