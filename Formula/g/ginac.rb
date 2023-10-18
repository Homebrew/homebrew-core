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
    rebuild 1
    sha256 cellar: :any,                 sonoma:       "20aa8a3ddee662108a4d9abcca8efbb439a42b6518621604c2cd9f2f8358d21e"
    sha256 cellar: :any,                 ventura:      "eea2055db77984131bb8e266e1011838c5d988a990c2268ef0f0f721a75d1a1c"
    sha256 cellar: :any,                 monterey:     "c05da698a6f66bc30300c78da3ba78ab1a9f7b83aa039b93435768f9ca74a7bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "125b63819d971c7ca2fdc1edbe2234d8acf21bc8852ee2db4d728406bd056984"
  end

  depends_on "pkg-config" => :build
  depends_on "cln"
  depends_on "python@3.12"
  depends_on "readline"

  def install
    system "./configure", *std_configure_args
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
