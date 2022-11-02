class Liburing < Formula
  desc "Helpers to setup and teardown io_uring instances"
  homepage "https://github.com/axboe/liburing"
  url "https://github.com/axboe/liburing/archive/refs/tags/liburing-2.3.tar.gz"
  sha256 "60b367dbdc6f2b0418a6e0cd203ee0049d9d629a36706fcf91dfb9428bae23c8"
  license any_of: ["MIT", "LGPL-2.1-only"]
  head "https://github.com/axboe/liburing.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c9e7e81e663c3aa8c61489a3f9eac9f3d48ff9d90a8d3d309030d26814e67b03"
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
