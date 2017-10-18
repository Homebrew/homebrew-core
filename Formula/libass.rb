class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage "https://github.com/libass/libass"
  url "https://github.com/libass/libass/releases/download/0.13.7/libass-0.13.7.tar.gz"
  sha256 "008a05a4ed341483d8399c8071d57a39853cf025412b32da277e76ad8226e158"

  bottle do
    cellar :any
    sha256 "72377d1cf3f27c3fd8aa3c5c09f90d95381100e839640fbc634110de2f0cd0c4" => :high_sierra
    sha256 "cc7d1e9db4ecabd76d0fbae0e4fdec4b8d30b5ff65064c3308e00265fe26b060" => :sierra
    sha256 "a6875e1e74496f2498204fa7e3c86fcbc8695b5f3ba91e3eaabe23986e4edb10" => :el_capitan
    sha256 "829f16aa3e2e7004b024b5ddf0a246efcd56aad297d1bb453a712a91cc4ddf1c" => :yosemite
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
