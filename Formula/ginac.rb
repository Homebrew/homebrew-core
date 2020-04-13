class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.7.9.tar.bz2"
  sha256 "67cdff43a4360da997ee5323cce27cf313a5b17ba58f02e8f886138c0f629821"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0a7e5283c3d9a13f52bd640cae0f7876df400cb3f3283d59eaadcf42283edf95" => :catalina
    sha256 "f7845dbd3403d80af469247432235fbed0f1aec485b047c741f52690985d26ac" => :mojave
    sha256 "ea3e9acfd79cb540a54788ea1ad0331e5123735bb432e08d5f1d5f5e1e6e0e36" => :high_sierra
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
