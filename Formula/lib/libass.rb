class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage "https://github.com/libass/libass"
  url "https://github.com/libass/libass/releases/download/0.17.4/libass-0.17.4.tar.xz"
  sha256 "78f1179b838d025e9c26e8fef33f8092f65611444ffa1bfc0cfac6a33511a05a"
  license "ISC"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bb0721a4dc29f2bdff8decdcafebc18199381f48d270070d13f56b19ef17944a"
    sha256 cellar: :any,                 arm64_sequoia: "8f95ded463c17df0c2aab2c740af0139bc4a0cdbcfb5166fd8f08dfecfadb2ee"
    sha256 cellar: :any,                 arm64_sonoma:  "5c1a3edc4205935aef54e4145f34dc5af961eabd8fd0d9873263099443cb7646"
    sha256 cellar: :any,                 sonoma:        "f35ce2f83bf6547a43cebd2c410dff6e06125fe5b293e3bfb053525422fa9825"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24e7d218a421d7f5e68231640235508682e8a49178179b5b9f3771686c01f859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3be86876627e29d2d7ce71dfac1df3afe013af1cd065b5367b43b25d64d01f17"
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
