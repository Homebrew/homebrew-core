class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.01.02.00.tar.gz"
  sha256 "808440da595299085190d171d2c354e25ed3911191beb9876cd1e1ae65ccdae4"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6b3fc53124ef9466dc1312c2e24ec8cb68446f054aa3d8974168b493fe7ed878"
    sha256 cellar: :any,                 arm64_monterey: "3d5dc8a0e5125bfcbd70c50bb181848152b8c01e961f094bf6572426dc913bff"
    sha256 cellar: :any,                 arm64_big_sur:  "42bd6ecfd943bf8f26ab6a49c9ea77e6efa36e8a9f22ab31ea02015eef865550"
    sha256 cellar: :any,                 ventura:        "5deadc7ca09a42864c65f3a539a4fe88a6b126247d1ff80812c4eb206a232e05"
    sha256 cellar: :any,                 monterey:       "07ecc15a19df4690b8ac7ab7448a179bd7b2c7d350235eac57e27bc06d9f0991"
    sha256 cellar: :any,                 big_sur:        "0dcbee9602146e996455b1f6824e47ccd47bd93ad0bbe303e4bba55753d2e995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dedd56b95668ce52c959b0bf1774a081920911378a5727d14f08ba35a8eaafac"
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
