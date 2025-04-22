class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.47/libpng-1.6.47.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.47/libpng-1.6.47.tar.xz"
  sha256 "b213cb381fbb1175327bd708a77aab708a05adde7b471bc267bd15ac99893631"
  license "libpng-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/libpng[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b4a7f252793b6a2d9d111cecaf5f0c91fd91d9c1c174a8796a487621a05f6f24"
    sha256 cellar: :any,                 arm64_sonoma:  "7f70c8ad51ae4da8e25564523c6e4eaf684693d61009246f11ea4e86e6a4e73b"
    sha256 cellar: :any,                 arm64_ventura: "df1cb9573402b54fc2734ef48a046c9dcfe5dad5e13299882b2e8ce1f926b0e9"
    sha256 cellar: :any,                 sonoma:        "d5f62a5676999c7ad51c469dee4135b4760dec9170b6c44cbb64493617b7b090"
    sha256 cellar: :any,                 ventura:       "45d50d4bd1acb8e6a3e3e072ec38679fd97dd81f8e950ed983c24c5452b45ab3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "210937c159f310c0949443bfdc630093bea9565b96760947628bff4d616a894b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8593cf808ca5ac81c78627bec4bae8f761fdd4f773a82ff441875efcc2b1fb0c"
  end

  head do
    url "https://github.com/glennrp/libpng.git", branch: "libpng16"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "test"
    system "make", "install"

    # Avoid rebuilds of dependants that hardcode this path.
    inreplace lib/"pkgconfig/libpng.pc", prefix, opt_prefix
  end

  test do
    (testpath/"test.c").write <<~C
      #include <png.h>

      int main()
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
