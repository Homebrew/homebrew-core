class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.43/libpng-1.6.43.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.43/libpng-1.6.43.tar.xz"
  sha256 "6a5ca0652392a2d7c9db2ae5b40210843c0bbc081cbd410825ab00cc59f14a6c"
  license "libpng-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/libpng[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "37936ba5cd5a1e736908a26fd2a944e04d86694a55f99fe5e173bfacac90e2e8"
    sha256 cellar: :any,                 arm64_ventura:  "a94e8b28177fa5015a8799b5147aa4ac28ec07bd0d8f913d33a67f155e442301"
    sha256 cellar: :any,                 arm64_monterey: "b41f32d6d5dc6172f9008cf4e9ca8c0595f7c5f10076742a134740c119051ce1"
    sha256 cellar: :any,                 sonoma:         "12d4c09fc08f07816fd485c6e64d07e17426cce36bcd525292089bb80d4ecf22"
    sha256 cellar: :any,                 ventura:        "37ae0c13a861618b896194178705949887b13821f4762888d1a624c79d08ab4e"
    sha256 cellar: :any,                 monterey:       "048eff2f9c2e1158a8deb1bbbda916ce52d93a2ae91dabbe4ced7609337658c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af870ecc2a8824919dd700525424c92bad4567fc0efdc4626884f434af2b6ea5"
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
