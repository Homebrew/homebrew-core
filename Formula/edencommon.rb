class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2022.10.17.00.tar.gz"
  sha256 "3d73bc64f2700babeac3b4220ab9c1c2dff57af58dbc843bbabfeb2e768b7997"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6d4188a96b91fcec232557dd47b5ffd98d669acd0e8cf6be61e95c19460dfbfc"
    sha256 cellar: :any,                 arm64_big_sur:  "73445846a55956f8d92defb6988b1b21db1b4e24cfa06cc24e73e715e62a0be5"
    sha256 cellar: :any,                 monterey:       "9fe9b2537892bde2a621d8adc2dc4ca9e418a8d4e73f853020cf68e2bfc6d421"
    sha256 cellar: :any,                 big_sur:        "ffc2e7139928ec833390218a912f63088768097bad69596714721f2cc3f368df"
    sha256 cellar: :any,                 catalina:       "14375f0452edc078bc2d35d7c110fd3befbf9e839c76fbcda5969cec81d9a946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a47d3b89c69a5d146144a5c010ce65a4533986b2cf6625937c537db7526f563"
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
