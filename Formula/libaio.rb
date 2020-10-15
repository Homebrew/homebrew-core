class Libaio < Formula
  desc "Linux-native asynchronous I/O access library"
  homepage "https://pagure.io/libaio"
  url "https://pagure.io/libaio/archive/libaio-0.3.111/libaio-libaio-0.3.111.tar.gz"
  sha256 "e6bc17cba66e59085e670fea238ad095766b412561f90b354eb4012d851730ba"
  license "LGPL-2.1-or-later"

  depends_on :linux

  def install
    system "make"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libaio.h>

      int main(int argc, char *argv[])
      {
        struct io_event *event;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-laio", "-o", "test"
    system "./test"
  end
end
