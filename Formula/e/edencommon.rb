class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.09.18.00.tar.gz"
  sha256 "edb6d391d545c6039d9f8a56e5e3cf5b5ead928f1f468bd09e596b78119e65af"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6b31aa23135c773c66f005a6aa6f263d031427c5d290bd3fcd1b7fa2bd61a7af"
    sha256 cellar: :any,                 arm64_ventura:  "e211115ec54128668195fe4ea834f0690aaaaa7edfaa6cfddbd4a8f52f5a239a"
    sha256 cellar: :any,                 arm64_monterey: "66b358c620cdbefb1c689fac50236ce5cd4e38ece64ca8d48b40824aff9b438b"
    sha256 cellar: :any,                 arm64_big_sur:  "c524c43c6da421de5a08c595d6f317c7f2f72de974cd0c44e47ce710066a3d35"
    sha256 cellar: :any,                 sonoma:         "30e7fe47eedf6f27118574301c25cde3daa0d41ab2bedc301857c41f735152b2"
    sha256 cellar: :any,                 ventura:        "9f0508e4d2fbf0b0e8b7dc6a3f6acdcea6bec9dc299fb9b6fe1cac767823c2c5"
    sha256 cellar: :any,                 monterey:       "1f2f351c22e488e12ad4e05b63ab48fe807986162ce15194bf054c0214cd9b9d"
    sha256 cellar: :any,                 big_sur:        "65ab203a8ee8160230a1668cf58a091538a95cd8d3b50d3b4201756817a51142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71b18aee045790f2eea1dc093c550bb0539ced39aa9f57a87dab9d9894c6858d"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  # Fix linkage against folly
  # https://github.com/facebookexperimental/edencommon/pull/10
  patch do
    url "https://github.com/facebookexperimental/edencommon/commit/b162c1b8d94b4ed49835da6d03b4d0a550082b47.patch?full_index=1"
    sha256 "99c299fa6df887d1e72aed3d60a8ca32eb2eda1897715482af8ddfa4702fe24c"
  end

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
