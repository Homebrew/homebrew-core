class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.7.4.tar.bz2"
  sha256 "d60413a2dc4e65b3832491fdcdb03897e673f8ff69885f015e74a6e9c7d978ef"
  revision 1

  bottle do
    sha256 "9d1ac5fac877c621ece3f0d0e4173c4b764a73b4cf0d6a08db260d1a6a29d1f9" => :mojave
    sha256 "34b12f8c03cc21a11302f1c59b3852cd23563a071dda751b1004986801c0462e" => :high_sierra
    sha256 "cd530a6c9656240a5afd12b03b30a7fc4a3724646150e78e86868206c2d816ac" => :sierra
    sha256 "5ea2a6631c79b96a700f0706bd7a8cc2983a37f368040df029f0621aee1bdd82" => :el_capitan
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
