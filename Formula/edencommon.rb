class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.01.02.00.tar.gz"
  sha256 "808440da595299085190d171d2c354e25ed3911191beb9876cd1e1ae65ccdae4"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1b5cea7d3caa8d4ba021237b6a0b8881d45ac6e7fabaafe7b1be86390e69e7f3"
    sha256 cellar: :any,                 arm64_monterey: "18674d869bba1c74590b6be899f01e966875d1ec362b6f69acde5b9520eb2268"
    sha256 cellar: :any,                 arm64_big_sur:  "2d554a5eaeac7254fc9811e62f5d7c831ea158054aedaeddf6d093613da171d3"
    sha256 cellar: :any,                 ventura:        "fdfb56fc54b288711bca01bdcc5f6b413a24c73572c6a7ab373f9cd19802b675"
    sha256 cellar: :any,                 monterey:       "c416bac3ca47aa5e48fb1d88b88849955c054aa7a013a308b9e49e74b8f1336c"
    sha256 cellar: :any,                 big_sur:        "9151467ab8fcff338a62576ae64a5b7fd108519c822a98c2945d03afa2111749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eee3515ac8871797326d547b027aaed3c1b2e348a28da6efcff116d7896fb8e0"
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
