class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.8.1.tar.bz2"
  sha256 "f1695dbd6b187061ef3fba507648c9d6dba438f733b058c16f9278cbdcf5e1ab"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.ginac.de/Download.html"
    regex(/href=.*?ginac[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 monterey:     "1fab055efe4ce1208e59f0a91dc7f34abd4a2890d07f04fe8dce3e8d7eaee80b"
    sha256 cellar: :any,                 big_sur:      "d1001c3d4a1975402462d266d715a584dc63b8ea9221cd680de70818237785f1"
    sha256 cellar: :any,                 catalina:     "3b28c3417ab90c06f4d86556bc51d51e7c17b05930adba6b71bd7091e22ade48"
    sha256 cellar: :any,                 mojave:       "bb5a12c6fa1e5ad8e5d29304c0ca6e7bef7bf83799545ee45a4b5608a0ef7a88"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "218209fcd3fab207b046dc8bbb781f8cf4831e97df1c38c657258d2ddd517d38"
  end

  depends_on "pkg-config" => :build
  depends_on "cln"
  depends_on "python@3.9"
  depends_on "readline"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

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
