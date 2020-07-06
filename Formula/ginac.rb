class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.7.10.tar.bz2"
  sha256 "e9ff2cc2d66e4181daf3a95405be7aa337f0446f5035e157b8c811eba10e51af"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "8cca55fc95511ccc59a7fad241b9359954ac105f74332058773ac4aa5dc8028a" => :catalina
    sha256 "603c9d1e9b2e3bce8ac26887b78319a428f8a066a576ab3ac1ac2ae603ee67b4" => :mojave
    sha256 "689107e33f99de6bbec419a1f252861258d8737d536dc2f62732e74bae8211ba" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cln"
  depends_on "python@3.8"
  depends_on "readline"

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
