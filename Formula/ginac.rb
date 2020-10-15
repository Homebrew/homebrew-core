class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.7.11.tar.bz2"
  sha256 "96529ddef6ae9788aca0093f4b85fc4e34318bc6704e628e6423ab5a92dfe929"
  license "GPL-2.0"
  revision 1

  bottle do
    cellar :any
    sha256 "5aa97c64e02bb68db70b2caa2c4af5f17f7871ef7ae3b075bcc4931be2748e58" => :catalina
    sha256 "3c5498d4814f09e728798b0b75537da316aae5c37438609fb9befa4f681590da" => :mojave
    sha256 "56f2147cc61429d2bf970d2b920d0dd493f10d8bb7e16f53490eb27f2a2aa16c" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cln"
  depends_on "python@3.9"
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
