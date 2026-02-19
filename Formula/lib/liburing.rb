class Liburing < Formula
  desc "Helpers to setup and teardown io_uring instances"
  homepage "https://github.com/axboe/liburing"
  # not need to check github releases, as tags are sufficient, see https://github.com/axboe/liburing/issues/1008
  url "https://github.com/axboe/liburing/archive/refs/tags/liburing-2.14.tar.gz"
  sha256 "5f80964108981c6ad979c735f0b4877d5f49914c2a062f8e88282f26bf61de0c"
  license any_of: ["MIT", "LGPL-2.1-only"]
  head "https://github.com/axboe/liburing.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "c5b6cfcdea7906367c5d6d15f85d994f671f4b92a21d7b603327288e56bd7120"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a93f7ddc433b025ba053e7aed0c6be08c439ae6259f2eb17dca6bf69122f3f68"
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
