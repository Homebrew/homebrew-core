class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2024.01.08.00.tar.gz"
  sha256 "6483402607ab83ee797c46acebde07b9c6bfd02182579dccd46780363774ef99"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ca9628cd2b804b54f3c56761addbc845c79502a3cf238831a417f16fdd5eff62"
    sha256 cellar: :any,                 arm64_ventura:  "3d616d3ec09b4e0f0c6acb4be927c5c3081f736d92adefba7650e7fa3ffa5189"
    sha256 cellar: :any,                 arm64_monterey: "7d2576f1932e852b2f06e0464ad80d09b6ffce0f166c03366664601b140d2a18"
    sha256 cellar: :any,                 sonoma:         "de021040e24943b48d2c31ade4633ef1e5906eaac4ce4c5cf7ffd3eeac18a4dd"
    sha256 cellar: :any,                 ventura:        "05155e68c9dd56b9fdb26f32b8b3041873e01122a9928d2dea9e467f657f7052"
    sha256 cellar: :any,                 monterey:       "6eef2e106d1da172552042e68496036d989f685aafe7776208db36d6915eac40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a5f8beb8d0e5147244369a08d422b0f638badf7cc8f613522e8099e3eef5c3f"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libsodium"
  depends_on "openssl@3"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace buildpath.glob("eden/common/{os,utils}/test/CMakeLists.txt"),
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"
    inreplace "eden/common/utils/test/CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

    system "cmake", "-S", ".", "-B", "_build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
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
                    "-L#{Formula["boost"].opt_lib}", "-L#{Formula["glog"].opt_lib}",
                    "-ledencommon_utils", "-lfolly", "-lboost_context-mt", "-lglog", "-o", "test"
    assert_match "ruby", shell_output("./test #{Process.pid}")
  end
end
