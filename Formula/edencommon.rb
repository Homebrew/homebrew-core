class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.03.20.00.tar.gz"
  sha256 "602aac2348396ea33b98dab9f94065900ed458a81ac32a42ec0b352c46d50046"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f97781192319a6b27912b90c58781d92f96966416c4de3e3ec3e839adf986f8f"
    sha256 cellar: :any,                 arm64_monterey: "fd5ec34c00cc230b1cabd2d3bf03cf81c2a20a2c2d6aa218554e3c614312a6c5"
    sha256 cellar: :any,                 arm64_big_sur:  "f8ccefb74d77aac24d404e7e2a7b6c789766b606d020e958fb9f4b18bd475d34"
    sha256 cellar: :any,                 ventura:        "301a944ac47ad65d4e5fe1886e6b356c0364368394f7eaf845bdf210449b7d72"
    sha256 cellar: :any,                 monterey:       "092a04957979ad6907bd2e87c0e5686c1d6894a1563921c04828598aea8b3ba4"
    sha256 cellar: :any,                 big_sur:        "47c6fe02e21e76c5cb0c87b6e43b202ba2c43cba15eb1d15e71da1c10110b78a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20fde173e35c6de974dd34687fcfd8adbced7c6178c1fccd5af00bb8dcec7545"
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
