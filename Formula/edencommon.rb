class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.01.30.00.tar.gz"
  sha256 "c414436974a9afacda21dcb535c124307b6b482b4d162d37b53ba891f72fcae2"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "adc52dbe1f75bba4fc159d3e0ce8c54dd8bf0369253741a623a5c76dbbf27462"
    sha256 cellar: :any,                 arm64_monterey: "160bfc23fa6e7d2e5d5eb709cca703669b4070997d0a079014f98c42731a64ac"
    sha256 cellar: :any,                 arm64_big_sur:  "787c644153acc375f36149038c759eab64d26d72ea4910bd100c83af4b463c33"
    sha256 cellar: :any,                 ventura:        "b5c67d40c247957c7ef6784d86f464ebc1781e46565f9d9931eabf10179e874c"
    sha256 cellar: :any,                 monterey:       "d4cec88acf30a344c6a1a09196f26e81cb68a8faba3ec89f32e3a5505f6e6c42"
    sha256 cellar: :any,                 big_sur:        "5bf1c773f1ac36b78a64225e28698f51138db8bf81a5d53c1d86647b0220eefc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c76a58d84bde9550b9c06504192be796802181789ba00c90881c2687f49e1642"
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
