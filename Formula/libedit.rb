class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "https://thrysoee.dk/editline/"
  url "https://thrysoee.dk/editline/libedit-20180525-3.1.tar.gz"
  version "20180525-3.1"
  sha256 "c41bea8fd140fb57ba67a98ec1d8ae0b8ffa82f4aba9c35a87e5a9499e653116"

  bottle do
    cellar :any
    sha256 "6717f6d821405c420aae5079c9d923ec3cd2a3ff62a6081c42f658e531faa64b" => :mojave
    sha256 "a8907ccf48a24561ad151f527dd7c6c7097600b71d564de5ef95a6bdba48a3b8" => :high_sierra
    sha256 "968593c13f12a4e12728fa319504a8786910efe4b38eda4290a0f9e674a31af3" => :sierra
    sha256 "556f24d0c21be5ecbb753e8c1bab7f60acf199bb77423370c1534b6046ffc482" => :el_capitan
  end

  keg_only :provided_by_macos

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
