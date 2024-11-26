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
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "9a7a204b5c3770f7d683be8e7010ce7746bb599302e7caee90eef1fa45abff55"
    sha256 cellar: :any,                 arm64_sonoma:  "f4a19bf3843043773daecc4e19a308eaf20e1370d78be953c03dd271e46744bc"
    sha256 cellar: :any,                 arm64_ventura: "11f66f760f919876085a014375f863d2a03613a5f9a26e1fef7aa0c673759619"
    sha256 cellar: :any,                 sonoma:        "c91f9809888fb6294d6839ab236eb3880d77cae084b5dc7ccf5950cdff267055"
    sha256 cellar: :any,                 ventura:       "5cd7b23d37eb77baab052cacb8cbcf36378d5dc38633593761c8810632c6de97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fdede5aa580316b0c9d774fc07455d659d760cb9fa76d10bec3eb47128b0cae"
  end

  depends_on "pkgconf" => :build
  depends_on "cln"
  depends_on "python@3.13"
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
