class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.7.11.tar.bz2"
  sha256 "96529ddef6ae9788aca0093f4b85fc4e34318bc6704e628e6423ab5a92dfe929"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "1f8cfa27de553a5d255476f6b9bf733e07b2a7fae0634c54cf3f76a6df70657e" => :catalina
    sha256 "d7ac7422a7cc3b9d629e5ec07af4882ebc6228a306d5a30b30fea9f0caaf0ed8" => :mojave
    sha256 "7a29a3fd12ee311e585dbd768fdb7a41634db388c76dd62d08435eec2d93738e" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cln"
  depends_on "python@3.8"
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
