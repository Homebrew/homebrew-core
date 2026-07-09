class Libevdev < Formula
  desc "Wrapper library for evdev devices"
  homepage "https://www.freedesktop.org/wiki/Software/libevdev/"
  url "https://www.freedesktop.org/software/libevdev/libevdev-1.13.6.tar.xz"
  sha256 "73f215eccbd8233f414737ac06bca2687e67c44b97d2d7576091aa9718551110"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "b1e035ed8ce1a581d5d9c317f04a158fc22a80ca48b8686971935424a3302311"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "70e3e3f2f3524ac16d9380aefe34e1f47d33a06a76a9f460d1bcfcd83df245f7"
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
