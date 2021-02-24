class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "https://thrysoee.dk/editline/"
  url "https://thrysoee.dk/editline/libedit-20210216-3.1.tar.gz"
  version "20210216-3.1"
  sha256 "2283f741d2aab935c8c52c04b57bf952d02c2c02e651172f8ac811f77b1fc77a"

  livecheck do
    url :homepage
    regex(/href=.*?libedit[._-]v?(\d{4,}-\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4d147b3faf124f55ff09117d8882ba96b605c29939c238083c13ad750d2749f2"
    sha256 cellar: :any, big_sur:       "c56ab224f48f895bcd3220fbb6c0b05d625d5e720785abab4c10f28ff8af1837"
    sha256 cellar: :any, catalina:      "6991169e0e1908adbcbdc1a578a27a47f237f9a1497bac29cfffa65055b0c9c7"
    sha256 cellar: :any, mojave:        "a5ba27ac97b4033f4277624712038bdae55865258b74bc2302c3c810218204a4"
  end

  keg_only :provided_by_macos

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <histedit.h>
      int main(int argc, char *argv[]) {
        EditLine *el = el_init(argv[0], stdin, stdout, stderr);
        return (el == NULL);
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ledit", "-I#{include}"
    system "./test"
  end
end
