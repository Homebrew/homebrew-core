class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2022.10.24.00.tar.gz"
  sha256 "73f5ff7c489316ae1158dbe94ee8a3fe809605d78cd53d6cbb8f543aa3b7dfa8"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "247e61da386e6a9910d30d58abf1d090dbb7edfcd19db0ea58fa2cffe587ad67"
    sha256 cellar: :any,                 arm64_monterey: "28c05bff4a4975b31e984e237433b4a3bb10552eb2264a246e9657125c70080f"
    sha256 cellar: :any,                 arm64_big_sur:  "126ba21efe7def3f0fcb60c41938497ffaeaf288a61ab4c5cc7917b3ca8503ed"
    sha256 cellar: :any,                 monterey:       "3df3dcec57e581eba1bfb16632fd804ce8f184563a16757f9e704b53f21856a6"
    sha256 cellar: :any,                 big_sur:        "91e524653181e46e19cb4b955283cda0caf5375a551dcd0bc74121844023901c"
    sha256 cellar: :any,                 catalina:       "263d2dd7e708c70eac5d65bd44875c1df31897f0bccd2820379134898041188a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74c083ffa2d6044892d2ad1dfa325047879b73b591d154d888afaf18fe851dc1"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"

  def install
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
