class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.03.06.00.tar.gz"
  sha256 "7b924d29b476068318c4afe559a0baced90b8cc8bab7ffc184b76887e7836fad"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5f74c3789acac12d6dfca094908636f92bea7fb5a568aeeb2858c6ec1dc3e801"
    sha256 cellar: :any,                 arm64_monterey: "06171aeea86f37b482d82b7815000575f3f1f9a595a8e75a60cba6e35042a2aa"
    sha256 cellar: :any,                 arm64_big_sur:  "19e26a66d21ee17752e93cc92234eaffa0e27f660012030ae5d3e1a3aa1e96d8"
    sha256 cellar: :any,                 ventura:        "4ff00b35f872ddf097798953265c159aadb313dc865149f2b1f935fcf66b10f1"
    sha256 cellar: :any,                 monterey:       "56639d41d4e1dda9b8d835b08c2608fe18fc19097525955c64f48ac7db72e75b"
    sha256 cellar: :any,                 big_sur:        "bf52e1959edd1912052818c7c3898c9f46ea02e428b8bf00d76d433a67bb4bb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17e69f69ba1c019b2b6747a898888a0b9c687a521640fc1bc8b22dca49cebd80"
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
