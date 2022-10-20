class Liburing < Formula
  desc "Helpers to setup and teardown io_uring instances"
  homepage "https://github.com/axboe/liburing"
  url "https://github.com/axboe/liburing/archive/refs/tags/liburing-2.2.tar.gz"
  sha256 "e092624af6aa244ade2d52181cc07751ac5caba2f3d63e9240790db9ed130bbc"
  license any_of: ["MIT", "LGPL-2.1-only"]
  head "https://github.com/axboe/liburing.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "56f202765112865ba402c9fe20f4b2571b586cff51e80632319ca451f3499f65"
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
