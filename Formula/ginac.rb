class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.7.4.tar.bz2"
  sha256 "d60413a2dc4e65b3832491fdcdb03897e673f8ff69885f015e74a6e9c7d978ef"

  bottle do
    sha256 "12fb4c423a2f2f8edbfb80e8418358d739c799d91b7972513de9fd030e589957" => :high_sierra
    sha256 "f6bd9aec1dd59e05c289d2db81f5c2d820447347a0e995684341f1c5fd5d32d4" => :sierra
    sha256 "02f150eca701df20c0e8629d8e5370ff93b82430dea360c188146fe7110e9e0f" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cln"
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
