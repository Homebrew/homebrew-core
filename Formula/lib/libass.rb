class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage "https://github.com/libass/libass"
  url "https://github.com/libass/libass/releases/download/0.17.5/libass-0.17.5.tar.xz"
  sha256 "2dca25c0e0c837ddf00b52011b3f82cac1e4ddd3ad018227806b0c2288864acc"
  license "ISC"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a066041fedbe188a5330faff55c9e3baac12f5d2ca156b7ae7d4cb1826ed8d84"
    sha256 cellar: :any, arm64_tahoe:       "29ac9a179908bc0c3d918b0f41fc40f7fbdfbc8819fa774ac85f0620b9281dc3"
    sha256 cellar: :any, arm64_sequoia:     "b893a0f114554c1b9ea3e046d8102d59c6cf98106936da144835310cab2878f3"
    sha256 cellar: :any, arm64_linux:       "3bec3705e79ddd9243520f702d071fdc7786e88b7759ca96f99f15bc2cfa5a52"
    sha256 cellar: :any, x86_64_linux:      "c07f0ce111a608118591aba37efc4c77643f6fe29a8c837efec9c093569f47d2"
  end

  head do
    url "https://github.com/libass/libass.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
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
    # libass uses coretext on macOS, fontconfig on Linux
    args = OS.mac? ? ["--disable-fontconfig"] : []

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lass", "-o", "test"
    system "./test"
  end
end
