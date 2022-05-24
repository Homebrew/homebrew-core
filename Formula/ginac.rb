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
    sha256 cellar: :any,                 monterey:     "4ab075211eb1e1fab5b466b491d47b6889da19ef9ccf2694a6cb766e14fb12b7"
    sha256 cellar: :any,                 big_sur:      "f3e5fd71ef3759a64566800e337a6f0d27fac8f3bcdb18a0ed027ac49e7f0c9b"
    sha256 cellar: :any,                 catalina:     "9b25545e28afb43aa06b4b5c6603b2d3fac5b0d187a3c6610658019e9147f445"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "661aab62fbae69222f682cc7c6130f49aefd7d3937dfc9c9da2bd4ad8a7a3695"
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
