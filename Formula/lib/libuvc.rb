class Libuvc < Formula
  desc "Cross-platform library for USB video devices"
  homepage "https://libuvc.github.io/"
  url "https://github.com/libuvc/libuvc/archive/refs/tags/v0.0.8.tar.gz"
  sha256 "abe134716f4c53fe60db2004b42adf6af60e64e45808135acfa4311454371ece"
  license "BSD-3-Clause"
  head "https://github.com/libuvc/libuvc.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d5e0b20b74f6584879ef4583c3883afea55ecda85a0280eb60a1a1aad6debf38"
    sha256 cellar: :any, arm64_tahoe:       "13896ab4b41c9436cd8b9e67a13b7286ce692b0e640a80b9651b00f44e820543"
    sha256 cellar: :any, arm64_sequoia:     "10e55f1f7eba992ea9b59a9917a091684adfb8b2218b3f549c79d7c86d2aca2d"
    sha256 cellar: :any, arm64_linux:       "40dd445816f4aebd65feb79922cd0adcf1b75b3142ed1a11b2fb73bacb391489"
    sha256 cellar: :any, x86_64_linux:      "3de0257f7e76ae8643796a9098c49677818a9f4b31d6da83caad79c726e2d458"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "libusb"

  def install
    # Workaround to build with CMake 4
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libuvc/libuvc.h>
      int main() {
        uvc_context_t *ctx;
        uvc_error_t res = uvc_init(&ctx, NULL);
        if (res != UVC_SUCCESS) return 1;
        uvc_exit(ctx);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libuvc").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
