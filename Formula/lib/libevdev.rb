class Libevdev < Formula
  desc "Wrapper library for evdev devices"
  homepage "https://www.freedesktop.org/wiki/Software/libevdev/"
  url "https://www.freedesktop.org/software/libevdev/libevdev-1.14.0.tar.xz"
  sha256 "5a0966c7110648665983848bad696c7acba614a2160d2865d535397101007332"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_linux:  "73e7c8138dd0955c482fa9e6fd87bbdfb89a3045b75deb1f4b4fda8a33d69bdd"
    sha256 cellar: :any, x86_64_linux: "92d31e986391308838c15131b8bc4acb64c0399ea85387cfae58ffacae3261e1"
  end

  depends_on "pkgconf" => :build
  depends_on "python@3.15" => :build
  depends_on :linux

  deny_network_access!

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
    assert_equal "Permission denied", shell_output(testpath/"test").chomp
  end
end
