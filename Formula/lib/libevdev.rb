class Libevdev < Formula
  desc "Wrapper library for evdev devices"
  homepage "https://www.freedesktop.org/wiki/Software/libevdev/"
  url "https://www.freedesktop.org/software/libevdev/libevdev-1.13.7.tar.xz"
  sha256 "0caf824971108f15bb2ad356433bae198d7d3bf1e82d43f63626e069e060bfa6"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_linux:  "341e16ad15b34c000d1c50d7ebbadf77ff4482ced4e55d8863032417dce60f03"
    sha256 cellar: :any, x86_64_linux: "28468dd362b31343eff6116d5943cc7ef917763bb627bb6cab6bc93c5b5d7c95"
  end

  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on :linux

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <string.h>
      #include <stddef.h>
      #include <stdio.h>
      #include <libevdev/libevdev.h>

      int main(void) {
        int result = libevdev_new_from_fd(0, NULL);
        printf("%s\\n", strerror(-result));
      }
    C
    system ENV.cc, testpath/"test.c", "-I#{include}/libevdev-1.0", "-L#{lib}", "-levdev", "-o", "test"
    assert_equal "Inappropriate ioctl for device", shell_output(testpath/"test").chomp
  end
end
