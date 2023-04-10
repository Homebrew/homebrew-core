class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.04.10.00.tar.gz"
  sha256 "a6d97a5e6f6776cd3d7798bb6da0f0e117294ca2742a8fd1aac672f49e5bf764"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "775bf2e0c1c019a2a646913e442df7a63f214b3abfdfce10d80dc0025176ba15"
    sha256 cellar: :any,                 arm64_monterey: "a70f072bb1c0f76242db3fefc82f3d5167afa0bd55b91c4ab516e50a8e0d8daf"
    sha256 cellar: :any,                 arm64_big_sur:  "2c7cc32dbbade62144fafc5f2549d8ad4e37e88e86f354885e5a6157b6efe9d7"
    sha256 cellar: :any,                 ventura:        "1e798b2d81fa716499c8a4bf5ad20abddc5423f905c6cdaabccbabb620de2e59"
    sha256 cellar: :any,                 monterey:       "aa48fe51f86aa8ca21098b1d733a26ef51aab2dc2798b76a6a9335fc227554c4"
    sha256 cellar: :any,                 big_sur:        "1829312bf2f695f485b47c97fd1ede483a1641ad6d31def9b335b3a4970fcc00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26b56b80943c4a0ee6c48e3e711319a6cac5afcd43c3dc4fb30d83fcde46af36"
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
