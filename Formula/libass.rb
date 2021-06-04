class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage "https://github.com/libass/libass"
  url "https://github.com/libass/libass/releases/download/0.15.1/libass-0.15.1.tar.xz"
  sha256 "1cdd39c9d007b06e737e7738004d7f38cf9b1e92843f37307b24e7ff63ab8e53"
  license "ISC"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6eb8abbcbba5ca09e35b9ff4c6fac078fbef383392677f42cc28ef735188165c"
    sha256 cellar: :any, big_sur:       "4545a55482e45e533c212e57c8a14660c547456072d68c2d2ed13c819f1300c5"
    sha256 cellar: :any, catalina:      "814ec97150e4fc19142f50a72ad366d6d46857520b20b5d7c20678af440b8dcf"
    sha256 cellar: :any, mojave:        "5178eda1fef01d6ab29af84953a29f00d13bf6cc1ceec05940da017891628970"
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
