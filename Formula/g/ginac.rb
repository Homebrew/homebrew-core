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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "fd73dcb1398309107724cf8b1e094ceff1d541cc7301b875bdc57876153fb284"
    sha256 cellar: :any, arm64_tahoe:       "42063245188d936f4ad0b3087ca1314d0b8fa4d055f8e35ca07dd22233cb8584"
    sha256 cellar: :any, arm64_sequoia:     "f15cbbcfe7a358f3c1d6b2e15b3e55aa5ff0f1b4cb9f8ae51da5a6cee6af5e16"
    sha256 cellar: :any, arm64_linux:       "3199a98ce2b6b61c4361d13497e9b7f7af541f9498d0a4042be5bed5127b0126"
    sha256 cellar: :any, x86_64_linux:      "4023287b0bdf4222019e5eb0897626ab012520c4319cbba2917e4fde98b45086"
  end

  depends_on "pkgconf" => :build
  depends_on "cln"
  depends_on "readline"

  uses_from_macos "python" => :build

  deny_network_access!

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
