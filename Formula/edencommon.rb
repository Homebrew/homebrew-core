class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.05.08.00.tar.gz"
  sha256 "e987b84c4cb2dbf62a44338dcd34d6829d756debb5516233351235015c87f31c"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fd2978ced7234e524685f5c89489c4a5e1add71f3ece7320f2ad47e8dc30eef8"
    sha256 cellar: :any,                 arm64_monterey: "4747cd6215fbe5aad840873d03177cec251353d9e64106dead681f160b966cea"
    sha256 cellar: :any,                 arm64_big_sur:  "d5698e9a32d23a4bd053810ff140ba9a9360d83eea73fa805b5b235f5f4ca863"
    sha256 cellar: :any,                 ventura:        "a4f2a215bae9e170f19c7b42e5cb75c8f672b2318113d790643e96a918d90a5f"
    sha256 cellar: :any,                 monterey:       "d2cdda93bc0708c612dc1acc84527b7d38dfb2e110c5e2c222dd12645a98c864"
    sha256 cellar: :any,                 big_sur:        "e49682381f6c6db433e58c01a7b2afe612dd4611ea1ee852797d0390b16f743d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5162a69c7dbf96e28faf0e97f7f2d8074bffb847cf8abb9f863867a262cec11a"
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
