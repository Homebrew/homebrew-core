class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.8.10.tar.bz2"
  sha256 "6cac1973a5325de0b9bcb8e392988ae95fbc37aa66c0f1f1d3b8e64c08cec1b9"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.ginac.de/Download.html"
    regex(/href=.*?ginac[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1dd266f5169a51f56de7328d2e8c14a4a163cbce58c1ec7f37d98c567be6f57d"
    sha256 cellar: :any,                 arm64_sequoia: "55455f94b98d31f81c40b65369e9d5b933080d9c56ef0a52c04da797f57f6a08"
    sha256 cellar: :any,                 arm64_sonoma:  "7e4c6e87845fdf4980d559de417705138e8569f1da6a6960efdb6db29fdd4f9a"
    sha256 cellar: :any,                 sonoma:        "6f2cf5490d43c329faa796449f917358f62fa7b0cd2fb9ccb07a2847095fa3c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf98079efbb1ede70fb28378ccc5b57f94aed5244c2359a6238e3cadc8d0ed27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c093bd89027bbead008692395d750aa955e16e82459bd610fb76de5ace53e48"
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
