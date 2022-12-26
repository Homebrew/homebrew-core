class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2022.12.26.00.tar.gz"
  sha256 "a8e06d184b219f8ae9f07b1bd4a44b205e50eebfbeb1fe3179daa5efd6878e82"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b36f3c13cee98093ec1b802db8c809f30375fd34651f23f90df751853ea7909c"
    sha256 cellar: :any,                 arm64_monterey: "f3f892524e98d1fe4c5915e52cea87f8a99eee426b573b6230557184f55e4585"
    sha256 cellar: :any,                 arm64_big_sur:  "4a60de0fed3c5b195c052b340c0a9a23dd35c2aa04ac5a9fa656724183e45c36"
    sha256 cellar: :any,                 ventura:        "387052c8b7b225c2624511ddfd7b9b9fc692440b6de44f88e24478d18fe69467"
    sha256 cellar: :any,                 monterey:       "fc15a560315dda2068708aed109eb12991b8325d4da8d54a83ddba716f1048db"
    sha256 cellar: :any,                 big_sur:        "1dbbe1d989d0fae0db470504b3a5be9d48cccf032a0dec93f0e8760881d9298a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "670422469fb0685aae99bbcd441ae0fb37d1a585650f87cd2a97995179366c48"
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
