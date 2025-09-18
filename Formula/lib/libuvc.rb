class Libuvc < Formula
  desc "Cross-platform library for USB video devices"
  homepage "https://github.com/libuvc/libuvc"
  url "https://github.com/libuvc/libuvc/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "7c6ba79723ad5d0ccdfbe6cadcfbd03f9f75b701d7ba96631eb1fd929a86ee72"
  license "BSD-3-Clause"
  head "https://github.com/libuvc/libuvc.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "f150b5d95ecef260fb7c6c2741fa52d102f8e9bd1712af32ebaf1785ec87dd39"
    sha256 cellar: :any,                 arm64_sequoia:  "94deef8d9e60b29d70cc1348b58cade333270747562c2ea151dcad2893757a84"
    sha256 cellar: :any,                 arm64_sonoma:   "fdde8f75b100e1b5c4880eade6ae2e1df144236a26a6757b59f935feadf45283"
    sha256 cellar: :any,                 arm64_ventura:  "6708c80f52e02d433eb7bc74ff598b8c6cc4a7963fb70f3757252abe94b021be"
    sha256 cellar: :any,                 arm64_monterey: "ad6af8f029ad6050565a30a2215b2e0a831d1acc0927cc032ba7b25754aa788b"
    sha256 cellar: :any,                 arm64_big_sur:  "110f3c38356127a1109273f022bedb51c4ee5a7df8845c4940db9a203a131627"
    sha256 cellar: :any,                 sonoma:         "71d65586d7c9129e23704c7ac10b5641c5705f357dd658f9e975865fac47d7a1"
    sha256 cellar: :any,                 ventura:        "3463a43797458c0e8d63446c9b54c2e8df213ca290f5a8bc08e3a071e7dad884"
    sha256 cellar: :any,                 monterey:       "e4dd5f0473e5f0f3a4d2b78f6b2b6fa556436055ef8a3d68d176a5b3afd3ca11"
    sha256 cellar: :any,                 big_sur:        "d974f8a7c94e5c106fa9c8bff6f85c0237ee1396d3dc672969d2279840cc0fac"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "def3a9096bee642658354acfd0d061a84a5d7f5560334c4564a7f0fb608cb35c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5adfe4cf8c0151495c6d82c4a1efba89a92a8d43e3d32803d6c88d015e894cf"
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
