class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.8.9.tar.bz2"
  sha256 "6cfd46cf4e373690e12d16b772d7aed0f5c433da8c7ecd2477f2e736483bb439"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.ginac.de/Download.html"
    regex(/href=.*?ginac[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "1a9026c3b92eaa538808ecc4eaa33955bea21fc1c519b5eb32bfbf516fd12650"
    sha256 cellar: :any,                 arm64_sequoia: "7229ec76e44d86f2eee54d5a6165b8e883f380710797b66e0c89acf4198a5b65"
    sha256 cellar: :any,                 arm64_sonoma:  "7be0eae553f3166e498d76d0aafa8fe2464dc12dd458994b717480369c1d41df"
    sha256 cellar: :any,                 sonoma:        "1ff80d411abfef5fe7123f2dda8c46cb2ca7896ce5159e72e1b18dcc95c5ecd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "016daa892e0c33325a2ae82a0defe16508e4b815ccf4ec76f981004d2f1102f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54551835a84d406210c8b4ee4ba16362f62147cc002004255845bc87fe4cdd91"
  end

  depends_on "pkgconf" => :build
  depends_on "cln"
  depends_on "python@3.14"
  depends_on "readline"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
                    "-L#{lib}", "-L#{Formula["cln"].lib}", "-lcln", "-lginac"
    system "./test"
  end
end
