class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "https://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.56/libpng-1.6.56.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.56/libpng-1.6.56.tar.xz"
  sha256 "f7d8bf1601b7804f583a254ab343a6549ca6cf27d255c302c47af2d9d36a6f18"
  license "libpng-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{url=.*?/libpng[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "293be4230646bf12d6ec509ad04fb7687d6bcb62e70f7662bb9f3a7082b02c2c"
    sha256 cellar: :any,                 arm64_sequoia: "90f24ecc6634943512f759636b45958a8df87f740cb77e3436543dace84c995a"
    sha256 cellar: :any,                 arm64_sonoma:  "c12fb89b2d4f107d82e71be5f70ba39f58da5fa78d5a244564e20d968d65620a"
    sha256 cellar: :any,                 sonoma:        "f4b55df78d51ddb24cd92eb73abb462520d0e1b11ff6d8c0f8fbe76b79bc9c17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dff215af8bf71c4ea63b6868d23e7301f382c2f7e80845cd6c162410feeb7789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c766bfc93270a082725d527bc42669309318b6d8e5bc6fa67a2e20bb92640ba8"
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
