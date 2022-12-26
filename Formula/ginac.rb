class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.8.4.tar.bz2"
  sha256 "27ce16aedfe74651b223bdb9246c00596b7ff9bf727a0d3a473f467000dac492"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.ginac.de/Download.html"
    regex(/href=.*?ginac[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 ventura:      "9d60352a7f0404255579994bef0ce1495e2819f6335f40c46d08c956f0e60285"
    sha256 cellar: :any,                 monterey:     "952b487955ae35fce8066b486f40c16d016db4014fc4fb7ade8bf2dcd9b6b681"
    sha256 cellar: :any,                 big_sur:      "15e7374d43ad7edac36e9518b669da627a15a5e1a580be0e5a1701cea3136298"
    sha256 cellar: :any,                 catalina:     "18993dacebeb61bc0143ff50ed72ad7ba2f4f000820e397e1f9fc075b04796d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5f3ca050e77efe63ad5f3a0327c14cac0ba7aa4a544da79b255cce5667b94cef"
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
