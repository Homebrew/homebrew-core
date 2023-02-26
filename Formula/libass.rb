class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage "https://github.com/libass/libass"
  url "https://github.com/libass/libass/releases/download/0.17.1/libass-0.17.1.tar.xz"
  sha256 "f0da0bbfba476c16ae3e1cfd862256d30915911f7abaa1b16ce62ee653192784"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "baa3b648fc992ec6809cedfabb7590cabca2dfea3c927e562191656a80d396b3"
    sha256 cellar: :any,                 arm64_monterey: "0b19597e0eb0d9a5bddc13e0a5bcc17b2bfd77a17b5cc5cddb68c208a6838609"
    sha256 cellar: :any,                 arm64_big_sur:  "091a8dc756479e45b245c0c913e39101991df611c9670ebf38e04fd4ad2d7c8b"
    sha256 cellar: :any,                 ventura:        "7d65f258e3f0ad6a7d60428c9982050ec18edf64aa22c91692fd4084a42dbe34"
    sha256 cellar: :any,                 monterey:       "eb7c43548a66b39afbc8822640b02531824f65e4293f8f6a0fa8c0addb874581"
    sha256 cellar: :any,                 big_sur:        "affb71cad007121bb77b910707e7d3c197fa73875b366d70e7b31d927bf05c13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccd2e410057e8e959628f5c95152fbb9137267cac65092f5ac6ad1e111b9bb56"
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
