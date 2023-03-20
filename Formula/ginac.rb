class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.8.6.tar.bz2"
  sha256 "00b320b1116cae5b7b43364dbffb7912471d171f484d82764605d715858d975b"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.ginac.de/Download.html"
    regex(/href=.*?ginac[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 ventura:      "d629bff3f9a0c95b390b9a3c698b84b4a05351d75e29fe2fe7b18bd5f2f4c1dd"
    sha256 cellar: :any,                 monterey:     "da4eec6b40b30508abaf8ae7a23da9a908134d668c7e344284b21ea6f10462a9"
    sha256 cellar: :any,                 big_sur:      "6c7f26dbf0499ab985401e36c39fc073ba405de86062ec6c9f0519d664658794"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c238c6914c2226dbf2fcef735be7369f4962848c228a3f0950b5826b70d1b26d"
  end

  depends_on "pkg-config" => :build
  depends_on "cln"
  depends_on "python@3.11"
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
