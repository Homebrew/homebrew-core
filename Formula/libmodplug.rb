class Libmodplug < Formula
  desc "Library from the Modplug-XMMS project"
  homepage "https://modplug-xmms.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modplug-xmms/libmodplug/0.8.9.0/libmodplug-0.8.9.0.tar.gz"
  sha256 "457ca5a6c179656d66c01505c0d95fafaead4329b9dbaa0f997d00a3508ad9de"

  livecheck do
    url :stable
    regex(%r{url=.*?/libmodplug[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "ae975c5a64bbb689329dc579f6997f2bd471b712a1d36e2055b1f94cf5bb927c"
    sha256 cellar: :any,                 arm64_big_sur:  "c3776d593085eda8a8fcf65c3ddb1419983a189381dfff047fe2a0ac2f7016e7"
    sha256 cellar: :any,                 monterey:       "f3ade438922dd6467216e1153ac89e017f3e665e96423d9d5fb7c9297f796202"
    sha256 cellar: :any,                 big_sur:        "64f182f657535f24a6f6a9fe6a351eced9f56a99bc0c0aef2f494079de6c2211"
    sha256 cellar: :any,                 catalina:       "62cb39e81cea4111f72a3f594ac78557f6f6992ae964321632fda16a16c97bd2"
    sha256 cellar: :any,                 mojave:         "67ea2db6931cc6f60ed71f09cfab02cb22d2781d2e5bbb96ff0ef6a22ebb1c83"
    sha256 cellar: :any,                 high_sierra:    "3f46eca3704d441ba8133d71bd283e8d24cff61e8b903fff720b78932185f9bf"
    sha256 cellar: :any,                 sierra:         "fc88a11e82b19a1a0aa4ada0ed3468147464d3414c3e9dffda9cea139b195c9d"
    sha256 cellar: :any,                 el_capitan:     "968a0bdc082725f136ab94f3a7eaf5a6a376eb94ec03b45f49ab275bd9193318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35918d9e7c950037e5184f85cd91d89ed308e478355dd9ad0ec8a312c69289d9"
  end

  resource "testmod" do
    # Most favourited song on modarchive:
    # https://modarchive.org/index.php?request=view_by_moduleid&query=60395
    url "https://api.modarchive.org/downloads.php?moduleid=60395#2ND_PM.S3M"
    sha256 "f80735b77123cc7e02c4dad6ce8197bfefcb8748b164a66ffecd206cc4b63d97"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    # First a basic test just that we can link on the library
    # and call an initialization method.
    (testpath/"test_null.cpp").write <<~EOS
      #include "libmodplug/modplug.h"
      int main() {
        ModPlugFile* f = ModPlug_Load((void*)0, 0);
        if (!f) {
          // Expecting a null pointer, as no data supplied.
          return 0;
        } else {
          return -1;
        }
      }
    EOS
    system ENV.cc, "test_null.cpp", "-L#{lib}", "-lmodplug", "-o", "test_null"
    system "./test_null"

    # Second, acquire an actual music file from a popular internet
    # source and attempt to parse it.
    resource("testmod").stage testpath
    (testpath/"test_mod.cpp").write <<~EOS
      #include "libmodplug/modplug.h"
      #include <fstream>
      #include <sstream>

      int main() {
        std::ifstream in("2ND_PM.S3M");
        std::stringstream buffer;
        buffer << in.rdbuf();
        int length = buffer.tellp();
        ModPlugFile* f = ModPlug_Load(buffer.str().c_str(), length);
        if (f) {
          // Expecting success
          return 0;
        } else {
          return -1;
        }
      }
    EOS
    system ENV.cxx, "test_mod.cpp", "-L#{lib}", "-lmodplug", "-o", "test_mod"
    system "./test_mod"
  end
end
