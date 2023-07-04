class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.07.03.00.tar.gz"
  sha256 "9d3677bafb9e201a320c11480347e14a468b7771e0659d871b9e1048a3b06f4b"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "60dd186c71f61e324f36e35f415e08588c8db22b63845f6474ab7c42a0c5b500"
    sha256 cellar: :any,                 arm64_monterey: "05f9884d119e89e56a924edd9e82502f6e4457681a5b79728f6827e1f06779c0"
    sha256 cellar: :any,                 arm64_big_sur:  "a39e4445ddf9902dc35076c69c2d191765f998a4d94baf3b46fab21a423c2e4b"
    sha256 cellar: :any,                 ventura:        "769c66b12bdb8a45a96e13f47bd793b24afcb48604597a39b104727c37e6f836"
    sha256 cellar: :any,                 monterey:       "e00b1eaa40674813beb65bf4400cb78a36779061403df11aedaa4e21332451ca"
    sha256 cellar: :any,                 big_sur:        "0a7cb43c9dd09e5b61b98393b29a23f7cbc4ee5917d919f3b7f78695db22129c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b0bfe418bff94b6d0adf45925005393038c19594060362ba967f2e2ef08d4eb"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

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
