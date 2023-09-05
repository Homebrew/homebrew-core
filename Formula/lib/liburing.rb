class Liburing < Formula
  desc "Helpers to setup and teardown io_uring instances"
  homepage "https://github.com/axboe/liburing"
  url "https://github.com/axboe/liburing/archive/refs/tags/liburing-2.4.tar.gz"
  sha256 "2398ec82d967a6f903f3ae1fd4541c754472d3a85a584dc78c5da2fabc90706b"
  license any_of: ["MIT", "LGPL-2.1-only"]
  head "https://github.com/axboe/liburing.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ec174e48971a9620626df860e7adc952fa4d5cb395fde8c0ccd9ea6a665d01ac"
  end

  depends_on :linux

  def install
    system "./configure", "--prefix=#{prefix}", "--libdir=#{lib}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <liburing.h>
      int main() {
        struct io_uring ring;
        assert(io_uring_queue_init(1, &ring, 0) == 0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-luring", "-o", "test"
    system "./test"
  end
end
