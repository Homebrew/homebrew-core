class Liburing < Formula
  desc "Helpers to setup and teardown io_uring instances"
  homepage "https://github.com/axboe/liburing"
  # not need to check github releases, as tags are sufficient, see https://github.com/axboe/liburing/issues/1008
  url "https://github.com/axboe/liburing/archive/refs/tags/liburing-2.11.tar.gz"
  sha256 "462c35ef21d67e50490f8684c76641ee2c7796e83d43de796852ef4e40662e33"
  license any_of: ["MIT", "LGPL-2.1-only"]
  head "https://github.com/axboe/liburing.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7ed93a64bc85e921e60d9e0461e63a8d3f3bddec04ecb273d617150b75022058"
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
