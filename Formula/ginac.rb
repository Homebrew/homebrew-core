class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "http://www.ginac.de/"
  url "http://www.ginac.de/ginac-1.7.2.tar.bz2"
  sha256 "24b75b61c5cb272534e35b3f2cfd64f053b28aee7402af4b0e569ec4de21d8b7"

  bottle do
    cellar :any
    sha256 "dacff9e73723b9f3e7340eed2c54d142a79a7e71748816071d120b4609c80b44" => :sierra
    sha256 "ca9596b46348b3d89a617e15b6366325f8a19b47797476cd539ab71a0246cf11" => :el_capitan
    sha256 "1785488b224b55b17e799afe462189c5ac49ef4b66159a83d724aced4633c933" => :yosemite
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
                                "-lcln", "-lginac", "-o", "test"
    system "./test"
  end
end
