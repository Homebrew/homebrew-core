class Liburing < Formula
  desc "Helpers to setup and teardown io_uring instances"
  homepage "https://github.com/axboe/liburing"
  # not need to check github releases, as tags are sufficient, see https://github.com/axboe/liburing/issues/1008
  url "https://github.com/axboe/liburing/archive/refs/tags/liburing-2.10.tar.gz"
  sha256 "0a687616a6886cd82b746b79c4e33dc40b8d7c0c6e24d0f6f3fd7cf41886bf53"
  license any_of: ["MIT", "LGPL-2.1-only"]
  head "https://github.com/axboe/liburing.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e8d2874f20a4896f14e8f95f53b33f86bfad226d810208248d420a09ad39d387"
  end

  depends_on :linux

  def install
    # not autotools based configure, so std_configure_args is not suitable
    system "./configure", "--prefix=#{prefix}", "--libdir=#{lib}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    # io_uring_queue_init test is required to modify sysctl options or run as root
    # and so it is expected to fail in general
    (testpath/"test.c").write <<~C
      #include <liburing.h>
      #include <stdio.h>
      #include <string.h>

      int main() {
        struct io_uring ring;

        int ret = io_uring_queue_init(1, &ring, 0);
        if (ret < 0) {
          fprintf(stderr, "queue_init: %s", strerror(-ret));
          return 1;
        }

        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{opt_lib}", "-luring", "-o", "test"
    assert_match "queue_init: Operation not permitted", shell_output("./test 2>&1", 1)
  end
end
