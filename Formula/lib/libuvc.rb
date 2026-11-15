class Libuvc < Formula
  desc "Cross-platform library for USB video devices"
  homepage "https://libuvc.github.io/"
  url "https://github.com/libuvc/libuvc/archive/refs/tags/v0.0.9.tar.gz"
  sha256 "825775b21b8558ac2afcbc2561ab1e5081898c9b0296673fcaa7cabb6e94078e"
  license "BSD-3-Clause"
  head "https://github.com/libuvc/libuvc.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8d0eb73050dc38d7b3f9b1ea67c1bdd3f63b1015e8176b22420f463d66daa8d0"
    sha256 cellar: :any, arm64_tahoe:       "faa9fad40a8c3996eb1fecc8b7423efc262c2e3ce082bfe9e1419c6666344216"
    sha256 cellar: :any, arm64_sequoia:     "a79956a7e56ec8daabff9b189021da651e18e9a61d988eb3d07bc620741eb3dc"
    sha256 cellar: :any, arm64_linux:       "3b6fa7380573054257b010db77ed52cb677b696cb30c1d8b9616ea8ab8487dd7"
    sha256 cellar: :any, x86_64_linux:      "fbd8a55dcb6621c91e7edc2f4dd09b19757a9721d4fd86810d707d178af6f5bf"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "libusb"

  deny_network_access!

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
