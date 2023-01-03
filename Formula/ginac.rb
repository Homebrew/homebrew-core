class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.8.5.tar.bz2"
  sha256 "c24b37a1e709f660d0978787e86b334803cd28ec17689cf36ddff380073ea261"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.ginac.de/Download.html"
    regex(/href=.*?ginac[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 ventura:      "85518e6ad146cfe4a5a8d6764f7b7b573e880e097cea5fd0c115a31ed28c7aff"
    sha256 cellar: :any,                 monterey:     "8f9c28d02c6e49a7a48e766c7bce80e99d6a54c29a520c184d82af92c3b8b345"
    sha256 cellar: :any,                 big_sur:      "55867c97f2e4763be2c53bfde7c4a67668e9deef977fea6581031f17c06084b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b4c54fdd8866e2f79b1a0e74ca5ff400e99eaecb350adc19a83bccad9712c570"
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
