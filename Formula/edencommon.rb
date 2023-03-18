class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.03.13.00.tar.gz"
  sha256 "93eec559fc89d2b825b70a441240eab4c9fb1f000b6dd665784e1d73a70f36ef"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5f28d0792c3df212bbaa408b07ebe4f5d7b24b8a5828331a9dd85a3b14bf6169"
    sha256 cellar: :any,                 arm64_monterey: "23275f13bbaa2ebdca04137d68dcc117f0cc1f1d47000c86b972bfb5c627d54d"
    sha256 cellar: :any,                 arm64_big_sur:  "4792238d3b8cf96177e280c8aa27379270da667863e5cb3f208db2146fd046b3"
    sha256 cellar: :any,                 ventura:        "bf752dba7fc0f878d76550f6149ceb298ae8799a5e97c7dd3961e59dab9f83ac"
    sha256 cellar: :any,                 monterey:       "97c98f6b7c70c23ef07c67cd9b0da20621942047b6899ace2c7e3e85572a9289"
    sha256 cellar: :any,                 big_sur:        "10043d145011a673c3a321082b166037aae72c9f544c0f7fc9e7556274fb0cef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c68e2a6622da71a9b74eb80dcbc30c86df316832f39427bb3ec666479afae24"
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
