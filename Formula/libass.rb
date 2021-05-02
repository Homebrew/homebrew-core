class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage "https://github.com/libass/libass"
  url "https://github.com/libass/libass/releases/download/0.15.1/libass-0.15.1.tar.xz"
  sha256 "1cdd39c9d007b06e737e7738004d7f38cf9b1e92843f37307b24e7ff63ab8e53"
  license "ISC"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7b5bbe38be42f70ee92bc06d2dc69680717c8f3bf33c3442f4cdd6bc328eb605"
    sha256 cellar: :any, big_sur:       "e95df755d6236cb7a56140c4bc12faad1d87023d23412b9f245bbda60073bf00"
    sha256 cellar: :any, catalina:      "427b18a8c9c8c5331553c0e814bf4e4c6f965cc53715d89a0ad3ba66b8e231c4"
    sha256 cellar: :any, mojave:        "64f2a67f35510fe088f3e6e18075d5e08e93081d958fcee6b65ee29ab3b730ad"
    sha256 cellar: :any, high_sierra:   "881db49f437027abdae60f4c849097b720216bcfa197589aea373b5f3451f9ef"
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
    on_macos do
      # libass uses coretext on macOS, fontconfig on Linux
      args << "--disable-fontconfig"
    end
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
