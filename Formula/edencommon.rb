class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.01.23.00.tar.gz"
  sha256 "242ffb640473faa1b8e827e5e0f002a1b963ed49a3e6d3021c939a166fd04f14"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8875c2ccd0f972e769b13c84a7b2204f59f4e30fc7100e4662c8396a39e6b9ad"
    sha256 cellar: :any,                 arm64_monterey: "a9eb3a974d1fef894f665a64c0bd6f4d10aeb7f9e15e2c494f4d6895923b16ed"
    sha256 cellar: :any,                 arm64_big_sur:  "f0c2695a7876992cb3b194ec8f1e26ba4faa9518ff6e3b47b295f677afad4b30"
    sha256 cellar: :any,                 ventura:        "6fbf0a492b55e4a06c507c2179865be9545aa1e482a4cfb8c87092d7b7b5a371"
    sha256 cellar: :any,                 monterey:       "eaaf888e19cbbb4a92c8afd2584d9b42e7baa2a7be3db0fada30397f04ecdbb3"
    sha256 cellar: :any,                 big_sur:        "c22e9cbf5f632e1b7b272654f2fa3c709cb2c71839ec2c6ba29f43f2196bc725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "febec90369dcb399df359d5d8aff4d6acc08223d837d113acf195c8697caa4b1"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace "eden/common/utils/test/CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 30)"

    system "cmake", "-S", ".", "-B", "_build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <eden/common/utils/ProcessNameCache.h>
      #include <cstdlib>
      #include <iostream>

      using namespace facebook::eden;

      ProcessNameCache& getProcessNameCache() {
        static auto* pnc = new ProcessNameCache;
        return *pnc;
      }

      ProcessNameHandle lookupProcessName(pid_t pid) {
        return getProcessNameCache().lookup(pid);
      }

      int main(int argc, char **argv) {
        if (argc <= 1) return 1;
        int pid = std::atoi(argv[1]);
        std::cout << lookupProcessName(pid).get() << std::endl;
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++17", "-I#{include}", "test.cc",
                    "-L#{lib}", "-L#{Formula["folly"].opt_lib}",
                    "-L#{Formula["boost"].opt_lib}", "-L#{Formula["glog"].opt_lib}",
                    "-ledencommon_utils", "-lfolly", "-lboost_context-mt", "-lglog", "-o", "test"
    assert_match "ruby", shell_output("./test #{Process.pid}")
  end
end
