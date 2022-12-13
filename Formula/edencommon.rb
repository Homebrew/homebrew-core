class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2022.12.12.00.tar.gz"
  sha256 "23fb00c98882b104141459f8efe1f372dc0442ec8d02ec844e3839c1b87beb29"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1e9f9f989a15f7910ed58e4c4139a8e504ff9efb07c02cedfc45225750aa780e"
    sha256 cellar: :any,                 arm64_monterey: "4f3b25342c1e3ccaff4c5a9cdfd11f3a81e374388d388755cc655f1931b06f35"
    sha256 cellar: :any,                 arm64_big_sur:  "745d1e51387d80ec2d54445ceb1e7a16ae7aac4c0aa447d5d1b11bd5e9b87877"
    sha256 cellar: :any,                 ventura:        "48e430c96b5addd2705a6594ff81aeb936d5daf3d47b81bfd584c2f18334d982"
    sha256 cellar: :any,                 monterey:       "5215d7a1fbac4bdee484073bca96363cba82a498d1910ef2b93bbf3cd1d4ef63"
    sha256 cellar: :any,                 big_sur:        "0935a83509cdcac89a2ed467815426da098e4812876d356ebe7675012ca197e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b17317810fe9c442814d46ccf6b6544311f7231bfdc9cbade5a566e539507880"
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
