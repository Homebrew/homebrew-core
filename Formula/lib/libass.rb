class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage "https://github.com/libass/libass"
  url "https://github.com/libass/libass/releases/download/0.17.1/libass-0.17.1.tar.xz"
  sha256 "f0da0bbfba476c16ae3e1cfd862256d30915911f7abaa1b16ce62ee653192784"
  license "ISC"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6316d110d55eade88304bb723fd2c7bc24e814e7b976daf1ddd5d7b48bf99c47"
    sha256 cellar: :any,                 arm64_ventura:  "24f870fbdb8d65e224467e4c4b590618c4a3c5404767240f8c74ab31bd57288f"
    sha256 cellar: :any,                 arm64_monterey: "7a7ea07e614eb28673572af37c5b2d4022964cf1f4e38cb7bdcb960caac7154f"
    sha256 cellar: :any,                 sonoma:         "5c3afdb76ec87f33eaea1bb92dd0bfcac08676f280cc2abb554336e01b839b41"
    sha256 cellar: :any,                 ventura:        "2bb745a9cf3044cc4008e427299d1d5e32d02947fdb7d07d44894cac732fe5d4"
    sha256 cellar: :any,                 monterey:       "8e338c76dd27cab9c9c0439dc9580c4f0094906a1d46eaf542360db4cc06ec9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f63d3a08e07e8b5e29a67b200ac2ec45cb11f7e19399b95240178c7ccab3b6ae"
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
