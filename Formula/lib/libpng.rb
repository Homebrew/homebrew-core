class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.40/libpng-1.6.40.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.40/libpng-1.6.40.tar.xz"
  sha256 "535b479b2467ff231a3ec6d92a525906fb8ef27978be4f66dbe05d3f3a01b3a1"
  license "libpng-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/libpng[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3609754d26b85452e09739470224f17c7951fd52f440fabcb2b9ae5ac48a3eb5"
    sha256 cellar: :any,                 arm64_ventura:  "c309cf133ab08f4fd25210da897eaaff2603e9a7e1bdc178821c7e186fb9ee69"
    sha256 cellar: :any,                 arm64_monterey: "38e56707b1bb8748577eb187112e895cb0509c802d4416307a3db35ac2e5fb9a"
    sha256 cellar: :any,                 arm64_big_sur:  "bd0c0853926df0f1118b4b7f700ee7594cad881604fd76e711eeef1231700f50"
    sha256 cellar: :any,                 sonoma:         "2178ff2980d1eb5a5e847ffd4a78dfcbeab3dd894c0e8eec5f79b2215e6c1c46"
    sha256 cellar: :any,                 ventura:        "557a4044277365427a3f3e164de4b7376d8988bf2c065340827d333b96c540c3"
    sha256 cellar: :any,                 monterey:       "db472393c4921d42631483d8e88725b3ee95e50c1ff33a34e120494d342dca4d"
    sha256 cellar: :any,                 big_sur:        "c4f83c1860a79daac87a140dce046a16bafae60f064c4f5b6d25d568db2bf695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71da4cbafaa68617588df27d9b2f9523d7704f724ae6109ad5f06b317fbb78f2"
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
    (testpath/"test.c").write <<~EOS
      #include <png.h>

      int main()
      {
        png_structp png_ptr;
        png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
        png_destroy_write_struct(&png_ptr, (png_infopp)NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpng", "-o", "test"
    system "./test"
  end
end
