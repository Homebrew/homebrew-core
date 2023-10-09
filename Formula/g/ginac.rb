class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.8.7.tar.bz2"
  sha256 "71ff4f2d8a00e6f07ce8fee69b76dcc1ebbb727be6760b587c1fbb5ccf7b61ea"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.ginac.de/Download.html"
    regex(/href=.*?ginac[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 sonoma:       "5c896b479e8dbeae784dfe4549880b82bbde32a619ce6be8d259c6b990b1775f"
    sha256 cellar: :any,                 ventura:      "6b1f54f17f7035edd80c36af3402485f99654fe651c8c06e55eebc886ceef480"
    sha256 cellar: :any,                 monterey:     "2e32ee246037520340c63cb173593b22e88aa49fd67fde26e2a990effe68a36e"
    sha256 cellar: :any,                 big_sur:      "5a0597e100de5340db7682e7ef2a4609eaa7eb87817f933fd13ff3de243238a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dbabf993c6a4453301f92b8697a6e10f865def6d817eebed7c57ae548edaf018"
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
