class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.7.8.tar.bz2"
  sha256 "0c86501aa6c72efd5937fce42c5e983fc9f05dadb65b4ebdb51ee95c9f6a7067"

  bottle do
    cellar :any
    sha256 "ada6219452caa90db7d3c79970d23a17ee7003b20355d8866356fcf0c5daee19" => :catalina
    sha256 "2ca093815433050c5f90b5523cdb5360235f63ff484de5be72575d0e953c4b37" => :mojave
    sha256 "1a3774e043db787f9e4c2882912c345597fabc4a620a4099dd39bbedee516f80" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cln"
  depends_on "readline"
  uses_from_macos "python@2"

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
