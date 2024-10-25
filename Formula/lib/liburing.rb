class Liburing < Formula
  desc "Helpers to setup and teardown io_uring instances"
  homepage "https://github.com/axboe/liburing"
  # not need to check github releases, as tags are sufficient, see https://github.com/axboe/liburing/issues/1008
  url "https://github.com/axboe/liburing/archive/refs/tags/liburing-2.8.tar.gz"
  sha256 "3ed7891d1b2bbe743ef3fb6d0a4970e630aa02d7c7bd3b0212791fb7be815984"
  license any_of: ["MIT", "LGPL-2.1-only"]
  head "https://github.com/axboe/liburing.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a369928abdce516f5cbaedc983900a24b3e22d345f5942e0d62f464578095fbc"
  end

  depends_on :linux

  def install
    # not autotools based configure, so std_configure_args is not suitable
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
