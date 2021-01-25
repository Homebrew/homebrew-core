class Libaio < Formula
  desc "Linux-native asynchronous I/O access library"
  homepage "https://pagure.io/libaio"
  url "https://pagure.io/libaio/archive/libaio-0.3.112/libaio-libaio-0.3.112.tar.gz"
  sha256 "b7cf93b29bbfb354213a0e8c0e82dfcf4e776157940d894750528714a0af2272"
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
