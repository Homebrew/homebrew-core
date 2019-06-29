class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.7.5.tar.bz2"
  sha256 "e74b6bf42d120a162014d8c8b5e89decc9c37a0a772adfd45acb23ecda6d6887"

  bottle do
    cellar :any
    sha256 "9d1b29e27f00ce4e73523a225a97252918648566b729d6fcdf0b8fc12058e80c" => :mojave
    sha256 "3aef98960da7da142e1ebcdb2c76a4a095dc3eb7665ae3982f2862f2aa386d39" => :high_sierra
    sha256 "cd70440f6fe43ec1fae5e643ef2c5cf1bb3cb9861406b4b2718b3901deb33666" => :sierra
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
