class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "https://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.58/libpng-1.6.58.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.58/libpng-1.6.58.tar.xz"
  sha256 "28eb403f51f0f7405249132cecfe82ea5c0ef97f1b32c5a65828814ae0d34775"
  license "libpng-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{url=.*?/libpng[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a28e1e29bf508ddf89800c215a013694c2751ca63e8ae40aca859aff7bf7b02c"
    sha256 cellar: :any,                 arm64_sequoia: "3d976f549e04ea0695078e5d8a3ae08c62e4dccd2b92f5b83c3ee9f1708c001b"
    sha256 cellar: :any,                 arm64_sonoma:  "fd6cbd5d7a231b83e359fd96231bb3dd668124ab5c2009697dee906ace98fadd"
    sha256 cellar: :any,                 sonoma:        "c74a40635359b753e614fb0a69a32149179a27f79d3338d5c5b685f66e223967"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1443b4f2e5f5e870e8d4f286cabee11a5efc471506765f2262f3a8daa0471411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5099e23c861337cff22c4b5a8c4f110b5e3bb0a3f5686fcd62f6377fac894b3"
  end

  head do
    url "https://github.com/glennrp/libpng.git", branch: "libpng16"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"

    # Use Fedora's regenerated test PNG for zlib-ng-compat compression
    resource "pngtest.png" do
      url "https://src.fedoraproject.org/rpms/libpng/raw/49e9a06ca115aaa911dd3419ee79c1870d1428fb/f/pngtest.png"
      sha256 "f925a657a5343cfb724414c01e87afd4d60b1f82a46edc0e11f016a126f84064"
    end
  end

  def install
    resource("pngtest.png").stage(buildpath) if OS.linux?

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "test"
    system "make", "install"

    # Avoid rebuilds of dependants that hardcode this path.
    inreplace lib/"pkgconfig/libpng.pc", prefix, opt_prefix
  end

  test do
    (testpath/"test.c").write <<~C
      #include <png.h>

      int main(void)
      {
        png_structp png_ptr;
        png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
        png_destroy_write_struct(&png_ptr, (png_infopp)NULL);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpng", "-o", "test"
    system "./test"
  end
end
