class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "https://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.59/libpng-1.6.59.tar.xz"
  sha256 "d80dd2a38a37f803cb9b6ac7b14bd6e74ddc3b654780a8380bdf93523fdb4389"
  license "libpng-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{url=.*?/libpng[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7e04225ac0bc048d2b12c603f678e5fa36459909812f2f1306dbd97af337cdec"
    sha256 cellar: :any, arm64_tahoe:       "de1c24778cb63a442682c1e6a391560662046a68c2f0c207ecb4abbc81e98cff"
    sha256 cellar: :any, arm64_sequoia:     "6461c4dde6a693b559c531357b32126bd649ab67f53db5a5b70c25a5c12de4f1"
    sha256 cellar: :any, arm64_linux:       "51e66ffc9fe346bc8a42733a5c0ef451d85a7a83192e57e313cc945ed788f210"
    sha256 cellar: :any, x86_64_linux:      "8955801e64761d8552a9cc206195694a438ab0b87cfe69f9ddbe9c29f69cfc50"
  end

  head do
    url "https://github.com/pnggroup/libpng.git", branch: "libpng16"

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

  deny_network_access!

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
