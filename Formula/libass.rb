class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage "https://github.com/libass/libass"
  url "https://github.com/libass/libass/releases/download/0.17.1/libass-0.17.1.tar.xz"
  sha256 "f0da0bbfba476c16ae3e1cfd862256d30915911f7abaa1b16ce62ee653192784"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0f5b7f92f0a546fdc3132dc9aba43cfa6a0c9817fea4ae5757c300eff84848e2"
    sha256 cellar: :any,                 arm64_monterey: "7d035facb52ae4af37f85aced182fa1500acc7b62a7ad1f0d0340215a7142f87"
    sha256 cellar: :any,                 arm64_big_sur:  "0ba42a7412c531c983e6485f1dc6f2751b29442189ac35398ebbfb556193b5e2"
    sha256 cellar: :any,                 ventura:        "690c44517e17fb4a72d442aa0b66942b4f5956a629dfbb5bb4a481917fb4083c"
    sha256 cellar: :any,                 monterey:       "f21c63595e10a2b146cb82dbc07fe2adb1bbcfefc4751c0ec33bb0cbc7994cbc"
    sha256 cellar: :any,                 big_sur:        "07e931e619def22ebab6739a7532479c837fae15222d99beb59aacbd4e308590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "980cf8c0847512a6ff3df227516c85d6b42fd9775a7b26dc40226be5b202fefd"
  end

  head do
    url "https://github.com/libass/libass.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz"
  depends_on "libunibreak"

  on_linux do
    depends_on "fontconfig"
  end

  on_intel do
    depends_on "nasm" => :build
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
