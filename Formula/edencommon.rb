class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.04.17.00.tar.gz"
  sha256 "56608b7b4a97b157dc57591a8bf55379e8e417cd891de80edc86f94f61cbc1c1"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0370d7d3f9842ad5d25d7ceeeaf49a315eaf1c37d00ae6c8c647792f8d017be3"
    sha256 cellar: :any,                 arm64_monterey: "62efcc97fc81ea9aab2046dc996d45021ad78e78e7809479865fa39e3262f863"
    sha256 cellar: :any,                 arm64_big_sur:  "d9ed867b8560356d11b13b1b96b6b4e43b3155301d58c1b72a76397d9b186cbe"
    sha256 cellar: :any,                 ventura:        "ae15d1e1455702a98abe41b0bcec8bb3751080a79b0bb50da1b1fb6bd74299c8"
    sha256 cellar: :any,                 monterey:       "cf83c6fcbfff3a1d9e323403e393ff8a238ab080e41b2276e88037bc19200d51"
    sha256 cellar: :any,                 big_sur:        "add8115a48e4354bb347dd31ce18fb100e7c058ce2dabd3f3ede8491a9b0d965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e60c40a35b654a4874d29e540661f5c31bdb7243b047e2d2e79bb0394ee042eb"
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
