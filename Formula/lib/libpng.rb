class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "https://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.55/libpng-1.6.55.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.55/libpng-1.6.55.tar.xz"
  sha256 "d925722864837ad5ae2a82070d4b2e0603dc72af44bd457c3962298258b8e82d"
  license "libpng-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/libpng[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "18e55305589da2de3f27d7162aa331bcaf020e3f50d1310fe14d4539d3d90281"
    sha256 cellar: :any,                 arm64_sequoia: "3219ece24a16bfc3b51f052101fc38213ff27fa12bfc866d6f7e4a28f70a9581"
    sha256 cellar: :any,                 arm64_sonoma:  "8f97640017cc367b9ef1049352f3cda54fd34686ec6b04eb58f34b8c26b85dbb"
    sha256 cellar: :any,                 sonoma:        "878c3075639e125f47cd730b7af85e4b1087dee15b08d9a9cbdaff6abf9ab8dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65fe1a45dab0ee25b54582b37968a5c5fb5e065ff22ad9debf05b948ca0525c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41f6eb3ea4da5e7996f09d3eb6ba9b02db91752f4b70c31abaee9a8bad1b7aa1"
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
