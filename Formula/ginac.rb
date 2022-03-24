class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.8.3.tar.bz2"
  sha256 "77c71a586adf6fc0b5dab573434f30cff1579153cd77c6eba02292e178f7a490"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.ginac.de/Download.html"
    regex(/href=.*?ginac[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 monterey:     "8f0a3d73801e6075b0d327b96163cdee33f343f4e92b98b3afc17cb647aef67f"
    sha256 cellar: :any,                 big_sur:      "d4506efbe735f7e139855cfe63089fe8f69ad79332ef6a6e52191666af53c552"
    sha256 cellar: :any,                 catalina:     "91f8da2327e83022ab1198c80a3aea34d2bed2cd12d1940915f3963aa9f15351"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0f3350bc62359b413ec62d69009139977641a97068edf8ae8aad7bb5c7eaa6f1"
  end

  depends_on "pkg-config" => :build
  depends_on "cln"
  depends_on "python@3.10"
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
