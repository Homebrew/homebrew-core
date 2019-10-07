class Libmodplug < Formula
  desc "Library from the Modplug-XMMS project"
  homepage "https://modplug-xmms.sourceforge.io/"
  url "https://downloads.sourceforge.net/modplug-xmms/libmodplug/0.8.9.0/libmodplug-0.8.9.0.tar.gz"
  sha256 "457ca5a6c179656d66c01505c0d95fafaead4329b9dbaa0f997d00a3508ad9de"

  bottle do
    cellar :any
    rebuild 1
    sha256 "62cb39e81cea4111f72a3f594ac78557f6f6992ae964321632fda16a16c97bd2" => :catalina
    sha256 "67ea2db6931cc6f60ed71f09cfab02cb22d2781d2e5bbb96ff0ef6a22ebb1c83" => :mojave
    sha256 "3f46eca3704d441ba8133d71bd283e8d24cff61e8b903fff720b78932185f9bf" => :high_sierra
    sha256 "fc88a11e82b19a1a0aa4ada0ed3468147464d3414c3e9dffda9cea139b195c9d" => :sierra
    sha256 "968a0bdc082725f136ab94f3a7eaf5a6a376eb94ec03b45f49ab275bd9193318" => :el_capitan
  end

  resource "testmod" do
    # Most favourited song on modarchive:
    # https://modarchive.org/index.php?request=view_by_moduleid&query=60395
    url "https://api.modarchive.org/downloads.php?moduleid=60395#2ND_PM.S3M"
    sha256 "f80735b77123cc7e02c4dad6ce8197bfefcb8748b164a66ffecd206cc4b63d97"
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
    system ENV.cc, "test_mod.cpp", "-L#{lib}", "-lmodplug", "-lstdc++", "-o", "test_mod"
    system "./test_mod"
  end
end
