class Libmodplug < Formula
  desc "Library from the Modplug-XMMS project"
  homepage "https://modplug-xmms.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/modplug-xmms/libmodplug/0.8.9.0/libmodplug-0.8.9.0.tar.gz"
  sha256 "457ca5a6c179656d66c01505c0d95fafaead4329b9dbaa0f997d00a3508ad9de"
  license :public_domain

  livecheck do
    url :stable
    regex(%r{url=.*?/libmodplug[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:    "1143c79498400dd323ef1a5e5c5e6ee7b6e1d6efc8cb742c63fa46b8cf7505b9"
    sha256 cellar: :any,                 arm64_sequoia:  "586ee0ddb6205b40860132f0f8dfdb74fdef762fb32ec0e9f2d3147db7229c63"
    sha256 cellar: :any,                 arm64_sonoma:   "8e1f55e5d02306627f7aba2c819f4432c3d96ef049da3e51a0163827558c0003"
    sha256 cellar: :any,                 arm64_ventura:  "169759bd85dac1257b3abc1f9690893711c64db8d8341278ecf10c155c4e8652"
    sha256 cellar: :any,                 arm64_monterey: "44f9536bdd1d88445e94cfef5c13a40ee07a965db04804824c438746f3d3db00"
    sha256 cellar: :any,                 arm64_big_sur:  "8f59c19b920e04fd0b2b71cab151e62358e1c8ff00bea83b3e40081f941c13d3"
    sha256 cellar: :any,                 sonoma:         "119d6db16f150a7398bd8209a230a13d47e0ab693b11c7671abf55be08e20f4d"
    sha256 cellar: :any,                 ventura:        "c5d06183c6979cfeca5ad1b02ae6303f4cf0949b064847f6d33529567fa9a4ac"
    sha256 cellar: :any,                 monterey:       "f773d6e23b5a2b84304c91c740b050c7364e3102714d4b1ccc3985e64f97d98e"
    sha256 cellar: :any,                 big_sur:        "2411526634753034b19df000bf941383eac622926cc50c31ff80dc5a484c7abe"
    sha256 cellar: :any,                 catalina:       "cd9af3b0e9c72274ac8a63934d0af44edb08cfbcfecc30772b862be74f68de9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0209868506e112abe52575b8604d3aa1ac4f804ef2fec00937ca15711a24ce7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d166a7f4a737de154ada685c9af4f82d22238a1b6cb323ce49a4496a3e9b2911"
  end

  resource "testmod" do
    # Most favourited song on modarchive:
    # https://modarchive.org/index.php?request=view_by_moduleid&query=60395
    url "https://api.modarchive.org/downloads.php?moduleid=60395#2ND_PM.S3M"
    sha256 "f80735b77123cc7e02c4dad6ce8197bfefcb8748b164a66ffecd206cc4b63d97"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

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
    CPP
    system ENV.cxx, "test_mod.cpp", "-L#{lib}", "-lmodplug", "-o", "test_mod"
    system "./test_mod"
  end
end
