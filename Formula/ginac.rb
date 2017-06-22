class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.7.2.tar.bz2"
  sha256 "24b75b61c5cb272534e35b3f2cfd64f053b28aee7402af4b0e569ec4de21d8b7"

  bottle do
    sha256 "f0d4538f1192bcc7cd609e430b821204286ba927fbddd95c0fb916309fac7734" => :sierra
    sha256 "299fa1acfa8338209289e3e622c3ebeb8faa873b9c04537247bf78b24293e2b3" => :el_capitan
    sha256 "ac20716d581c5e0e5db6326c1a4f3ef9528ecc3c50dbc6bb3c46e9df32e0b888" => :yosemite
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
    (testpath/"test.cpp").write <<-EOS.undent
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
