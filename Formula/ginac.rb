class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.8.0.tar.bz2"
  sha256 "44b4404a897dd7719233c44f3c73bc15695e12b58d3676cb57c90ddcddf72b51"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "84f3dc97d9ee0ccabd1ff0c950b0c83859a95cd06c9de5a8a9aae9d472ebd7c7" => :big_sur
    sha256 "9af774101ed69e14f7e060a85cd4a5edab1ecdda620e0e139085d09707dd2e6f" => :catalina
    sha256 "0671c4d1eea685f41fec545a143423c06c2e05758f9eb30f6c3678651d6531dd" => :mojave
    sha256 "9a11a9e1cf35094644e185c45860c58d1c21472cc839a061376eb1f79caf2373" => :high_sierra
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
