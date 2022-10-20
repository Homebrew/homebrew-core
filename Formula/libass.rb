class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage "https://github.com/libass/libass"
  url "https://github.com/libass/libass/releases/download/0.16.0/libass-0.16.0.tar.xz"
  sha256 "5dbde9e22339119cf8eed59eea6c623a0746ef5a90b689e68a090109078e3c08"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "78b33a83599fa08d424552a3bfae77cd00adc2bc343006e86300a0236d144afe"
    sha256 cellar: :any,                 arm64_big_sur:  "ca188b422309aa7962beeb2313be7d2976f4dfeff98a20de8ea5ad1522a7214e"
    sha256 cellar: :any,                 monterey:       "bdef66960d51e5e05cf78aca163ab3a8067e7d0589a7ddfbaaf8d4ffb32c319a"
    sha256 cellar: :any,                 big_sur:        "745323103a372dac6d5c81cb00cc02e9b51d2da99f8c0b08007c851977094e03"
    sha256 cellar: :any,                 catalina:       "4031a10db6546e55d4f8c9b23ab2b82fd0b960791641cd12189363a6bc425b47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52049797d742af4527e561aaee7ba8fde6d9f155291d58f7a3b9f9d8c8cd8105"
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

  on_linux do
    depends_on "fontconfig"
  end

  def install
    system "autoreconf", "-i" if build.head?
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    # libass uses coretext on macOS, fontconfig on Linux
    args << "--disable-fontconfig" if OS.mac?
    system "./configure", *args
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
