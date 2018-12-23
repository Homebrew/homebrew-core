class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage "https://github.com/libass/libass"
  url "https://github.com/libass/libass/releases/download/0.14.0/libass-0.14.0.tar.xz"
  sha256 "881f2382af48aead75b7a0e02e65d88c5ebd369fe46bc77d9270a94aa8fd38a2"
  revision 1

  bottle do
    cellar :any
    sha256 "36b9be3be830f1e944eb7484c1a1f1495d1c5f454430bca9526660c416c50998" => :mojave
    sha256 "2d8f9ced8b8d4d7327a79e86ddf80d01bfbb96e040a8ac56798d4e2513a26e90" => :high_sierra
    sha256 "67f577f99f875a5f4998fb5d5cac85ba67dd39ef3b1b76037759fd64c86548bd" => :sierra
    sha256 "f48697b75e514bc69f390803b1d7c8f748c9796ad332c4fdceebbc57402592a3" => :el_capitan
  end

  head do
    url "https://github.com/libass/libass.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz"

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-fontconfig"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
