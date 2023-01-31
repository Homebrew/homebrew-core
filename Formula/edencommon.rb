class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.01.30.00.tar.gz"
  sha256 "c414436974a9afacda21dcb535c124307b6b482b4d162d37b53ba891f72fcae2"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f47afe2786650eefe601de10376298da60457f6cb6f7a880bb3ad73d7b18d7d1"
    sha256 cellar: :any,                 arm64_monterey: "65ada0f9c917826c8e716366a950350079f36decd91977b9633104186d032869"
    sha256 cellar: :any,                 arm64_big_sur:  "25ea18780dbf2ca39f2151b15e23b20dae53498da749a2b27de2b966fda88bfc"
    sha256 cellar: :any,                 ventura:        "01490e3f3f0cd11387c4ef3a96e399d0094d33cb3472993f1bcb9b8d5dda2b29"
    sha256 cellar: :any,                 monterey:       "e564e8019599cd888b2f55559ca10dedf9c1e41b469920549315f265c4f92a8d"
    sha256 cellar: :any,                 big_sur:        "2749fb2b0729a496f295f29f79d59859768c248355dbbc1be4ca8b79de0a7454"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2352fd4924714c0e43abcc323593adb0bc1bf66fbc0a2dbcb3af24c04ce60dc"
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
