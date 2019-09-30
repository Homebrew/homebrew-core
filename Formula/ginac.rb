class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.7.7.tar.bz2"
  sha256 "0eff6eed729aa6e5a34ecbd2c0723e6e23dcd5a14346050eb66697ea19394ecb"

  bottle do
    cellar :any
    sha256 "23693af75cb9391dd6e8136ebef790bb33a5de78989636da1561527dec76133a" => :mojave
    sha256 "d2700b4f187e704b683e70129cecdd1070033f7cc695576c65cdafb96e753367" => :high_sierra
    sha256 "3ae47d735dd3f753899ab604a4f463925965da7cc99f91fad08fd8a15a1d22ab" => :sierra
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
