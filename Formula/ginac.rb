class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.7.5.tar.bz2"
  sha256 "e74b6bf42d120a162014d8c8b5e89decc9c37a0a772adfd45acb23ecda6d6887"

  bottle do
    cellar :any
    sha256 "bd77d833166418f2d43ba4425bb78c739307f5112d442a5bce4804eb8bdd18fe" => :mojave
    sha256 "65e1cc9d7a9af229d7f2b26323823fe7eb0540cb9c7f24f9fd65f0a55bec9fe4" => :high_sierra
    sha256 "fd1070f14cd58bb0121d335b9bbc71334e83a4cecb61eab8736c96064ce55f12" => :sierra
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
