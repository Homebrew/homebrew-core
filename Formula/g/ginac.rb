class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.8.8.tar.bz2"
  sha256 "330f57d0ed79dbd8f9c46ca4b408439b8b30e2ea061e3672d904c5dab94ecad6"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.ginac.de/Download.html"
    regex(/href=.*?ginac[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6d9ec318fc0e4b6c78b15fadde111f0872df880ec4bb949e3087ad153b672828"
    sha256 cellar: :any,                 arm64_sonoma:  "552f4fbd7b5622d7ede628471e6fb216877870951276152fcc472539e545637a"
    sha256 cellar: :any,                 arm64_ventura: "3d1b94dc22aae599565dfe9fea6ac54ca696f11cf5a3f50528c594d1ae39f95f"
    sha256 cellar: :any,                 sonoma:        "68229ef05f5b82e8750ce12bfb7c84997f85b2c067d49273c21e3c819aeff10a"
    sha256 cellar: :any,                 ventura:       "eddcfc320d3691fdebfd71a6f642ddeac843a4a319cca1c3a24fc5f9d045ca80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21027f247652621d6524998550631fc9eea5d77efa7914f10e3ef0562ee7965e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a010a1afcb6ed3b42ebb387ee863eebaef45c995bea1bbba87c0b7663f8c107b"
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
