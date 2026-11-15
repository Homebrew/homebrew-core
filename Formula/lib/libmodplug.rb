class Libmodplug < Formula
  desc "Library from the Modplug-XMMS project"
  homepage "https://modplug-xmms.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/modplug-xmms/libmodplug/0.8.9.2/libmodplug-0.8.9.2.tar.gz"
  sha256 "e4d9cb46da78a639d6eadb4ff3ab955f68c3099579b5310af64b37091e28957e"
  license :public_domain
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{url=.*?/libmodplug[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9014a2a4c7cfb30c08910e745fb0ae00d7ce7d1d157c2315a07e26649e4c919d"
    sha256 cellar: :any, arm64_tahoe:       "6efb09badf5149ba9de2a95478a7368d0b5a0cb15cfab76ce8b8411c582892a2"
    sha256 cellar: :any, arm64_sequoia:     "3ad7489e3a52048affa2e92b215ea7ac643647aa4503966d73b288f109165100"
    sha256 cellar: :any, arm64_linux:       "704a9e65b80b4fa457f4bb1002a8868e283a8fe80ddbdc381bb39aed5a7b51c9"
    sha256 cellar: :any, x86_64_linux:      "9c6801f8f9b31f5f1c6563f695b7b05841a7196d0540794f63833ceb20d8642c"
  end

  resource "testmod", :test do
    # Most favourited song on modarchive:
    # https://modarchive.org/index.php?request=view_by_moduleid&query=212083
    url "https://api.modarchive.org/downloads.php?moduleid=212083#2nd_pm.s3m"
    sha256 "b869c3e70c66010eda066452791cc3f1536bd3ad0bc01b98924c79765b03ceb2"
  end

  deny_network_access!

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-static",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    # First a basic test just that we can link on the library
    # and call an initialization method.
    (testpath/"test_null.cpp").write <<~CPP
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
    CPP
    system ENV.cc, "test_null.cpp", "-L#{lib}", "-lmodplug", "-o", "test_null"
    system "./test_null"

    # Second, acquire an actual music file from a popular internet
    # source and attempt to parse it.
    resource("testmod").stage testpath
    (testpath/"test_mod.cpp").write <<~CPP
      #include "libmodplug/modplug.h"
      #include <fstream>
      #include <sstream>

      int main() {
        std::ifstream in("2nd_pm.s3m");
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
    CPP
    system ENV.cxx, "test_mod.cpp", "-L#{lib}", "-lmodplug", "-o", "test_mod"
    system "./test_mod"
  end
end
