class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage "https://github.com/libass/libass"
  url "https://github.com/libass/libass/releases/download/0.13.4/libass-0.13.4.tar.gz"
  sha256 "6711469df5fcc47d06e92f7383dcebcf1282591002d2356057997e8936840792"

  bottle do
    cellar :any
    sha256 "832727089751a96f3f9c5396bd599efddad9c798c3ba99a3683c34f6fa9e05a2" => :sierra
    sha256 "b05ff9d2f699916570bfa9b956816dd5881d0fcf99edf7e6f60c4d500ebbf47e" => :el_capitan
    sha256 "c45fb01adcc54299c2dd35c4d32f1402436b7e7cfc6a3bf4f9db546e01dd0638" => :yosemite
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
