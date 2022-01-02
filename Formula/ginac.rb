class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.8.2.tar.bz2"
  sha256 "bfcd751abcaf8afddb83958c2ad22763a75ea24032553e503ee9b38e3ea3b6c3"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.ginac.de/Download.html"
    regex(/href=.*?ginac[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 monterey:     "21cd21883b723b4a4dc0bb4f29ac8a641cf18697be02b95db01a52566da7d287"
    sha256 cellar: :any,                 big_sur:      "5fc49d7357aed9862cdd9a08ee5bdcf98ee3b396d883685c1fbc246a44c21920"
    sha256 cellar: :any,                 catalina:     "ce496bf81091b0a051c7e8b1f2f042d71ccc974c462b264d7218f167a44b48c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a9751f11eecd351e0b096e58cc66bb6a87452ddae111f01ae4704ae86c5f26c6"
  end

  depends_on "pkg-config" => :build
  depends_on "cln"
  depends_on "python@3.10"
  depends_on "readline"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <ginac/ginac.h>
      using namespace std;
      using namespace GiNaC;

      int main() {
        symbol x("x"), y("y");
        ex poly;

        for (int i=0; i<3; ++i) {
          poly += factorial(i+16)*pow(x,i)*pow(y,2-i);
        }

        cout << poly << endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}",
                                "-L#{Formula["cln"].lib}",
                                "-lcln", "-lginac", "-o", "test",
                                "-std=c++11"
    system "./test"
  end
end
