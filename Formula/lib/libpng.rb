class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "https://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.57/libpng-1.6.57.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.57/libpng-1.6.57.tar.xz"
  sha256 "d10c20d7171569804cae8dfc13ba6dcd0662c41ed39d43d4d429314aafb10a80"
  license "libpng-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{url=.*?/libpng[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "840474525d72c6c7dca27d86adc00858dac9842eafb96b7c1d4be3441752cc97"
    sha256 cellar: :any,                 arm64_sequoia: "2424b2cbfdd0cd84a7c80782f142d7926e8b1803e0db5494d5135a68208f8123"
    sha256 cellar: :any,                 arm64_sonoma:  "327c67c9aec74ab6b7069e9769bd448f1f476210044cd068ab701aa26959bc58"
    sha256 cellar: :any,                 sonoma:        "603d755758265cf25faadf872c60d28ce84347af9ea8f74cadbd88ab192a5c9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6e8883756e0fcaf3a9b7527bf6729f24529726ea1d458ffadbc3a357275fd7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99165597f6dc3a96533aeb3bbb959b977b8c2cbafef68d869edb4de65f0a2b38"
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
