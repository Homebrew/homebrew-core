class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2024.05.02.00.tar.gz"
  sha256 "ef5c9d0e92a22172df6b09d25c2203e41d67b78ed8a57368c9e8d20f582876d4"
  license "MIT"
  revision 1
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00af2017324dfcf617ba6cf97942d01b12014b098711b9bcdb9c8f40011bd25e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f2389c7ebd8b249bce5cf34387c40324af523ec92f362f59e8ffa07ebabd6b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "026924a4ae6f4f66ab01b846657cd29f2547713eb414a31bb6559ac5a474b23a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a01498d04c02c4260f9a7f96f0a4c2f84fb63a17c940e9fa4b82f800bd4a4761"
    sha256 cellar: :any_skip_relocation, ventura:        "3d05cd5a7bdc9a08bce7aeca9fc415a7084912bbfdb46ce7b2e735805a749fef"
    sha256 cellar: :any_skip_relocation, monterey:       "07d1ec0f274af812fbfa05a37989eebfffa3f08d398d2e3c1391785c515f92f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d46111720435d40231c3926ee056353dfbbfe331384bf499b2851cdd66dd581"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "wangle"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace buildpath.glob("eden/common/{os,utils}/test/CMakeLists.txt"),
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"
    inreplace "eden/common/utils/test/CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

    # Avoid having to build FBThrift py library
    inreplace "CMakeLists.txt", "COMPONENTS cpp2 py)", "COMPONENTS cpp2)"

    system "cmake", "-S", ".", "-B", "_build", *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <eden/common/utils/ProcessInfo.h>
      #include <cstdlib>
      #include <iostream>

      using namespace facebook::eden;

      int main(int argc, char **argv) {
        if (argc <= 1) return 1;
        int pid = std::atoi(argv[1]);
        std::cout << readProcessName(pid) << std::endl;
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++17", "-I#{include}", "test.cc",
                    "-L#{lib}", "-L#{Formula["folly"].opt_lib}",
                    "-L#{Formula["boost"].opt_lib}", "-L#{Formula["glog"].opt_lib}", "-L#{Formula["fmt"].opt_lib}",
                    "-ledencommon_utils", "-lfolly", "-lfmt", "-lboost_context-mt", "-lglog", "-o", "test"
    assert_match "ruby", shell_output("./test #{Process.pid}")
  end
end
