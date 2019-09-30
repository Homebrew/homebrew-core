class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.7.7.tar.bz2"
  sha256 "0eff6eed729aa6e5a34ecbd2c0723e6e23dcd5a14346050eb66697ea19394ecb"

  bottle do
    cellar :any
    sha256 "f5135098d377f2a8969b9a3168070ed52635710ad317a6bfed62157a4db56173" => :catalina
    sha256 "2ba503fc69e45f964936e4ec7c0c385d7302462739c2cdd116293a3c6ae601de" => :mojave
    sha256 "451551e26a4f7fdb7f137fd3ab5adc5ae20d57ee0ac643ea32ef9cc7586d1fa7" => :high_sierra
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
