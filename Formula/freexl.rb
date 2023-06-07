class Freexl < Formula
  desc "Library to extract data from Excel .xls files"
  homepage "https://www.gaia-gis.it/fossil/freexl/index"
  url "https://www.gaia-gis.it/gaia-sins/freexl-sources/freexl-1.0.6.tar.gz"
  sha256 "3de8b57a3d130cb2881ea52d3aa9ce1feedb1b57b7daa4eb37f751404f90fc22"

  livecheck do
    url :homepage
    regex(%r{current version is <b>v?(\d+(?:\.\d+)+)</b>}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "d3b03b75eac2a439db87a56492103fe5eb0e619b1f5597cffc7f03bb11f4640c"
    sha256 cellar: :any,                 arm64_monterey: "f2f26c1449a3f79a89ec85deb5cd22507ee4715827afdf31469fd605c8a31b7f"
    sha256 cellar: :any,                 arm64_big_sur:  "57d5fc25946a587bfebb8724bff578688f605edcabba8cd80b9ebbf5840616d0"
    sha256 cellar: :any,                 ventura:        "3baeaebe274fc3c9db2a59278fbd334f5a009dfbf03614d63b6803097a5da85b"
    sha256 cellar: :any,                 monterey:       "0dc034f726d2ad3850742e7f9a1676d67c14c48fd9735470fd3691a3c080182c"
    sha256 cellar: :any,                 big_sur:        "a20523355d18f1ed2259ae198b45c5aa93080fbd4926e0eb6969d2919b7a97ac"
    sha256 cellar: :any,                 catalina:       "1bab8437de88ce5564702dcc3e30a9c2f9491aa9358e767aa3d8ec62ba76922d"
    sha256 cellar: :any,                 mojave:         "003e9d848f354e7f12232f85240f4892f21e6136cd657022fbbc51b3bd286225"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2059ac999e20b72d31a6e586174327431066c01e10c25fca93c80ef5d10f5b4b"
  end

  depends_on "doxygen" => :build

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules"

    system "make", "check"
    system "make", "install"

    system "doxygen"
    doc.install "html"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "freexl.h"

      int main()
      {
          printf("%s", freexl_version());
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lfreexl", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
