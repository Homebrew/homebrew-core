class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2025.04.07.00.tar.gz"
  sha256 "f9d1440a1a1c80bb9826f5cad1f5bdd2d1a8d12c8edd75d3eb2d9b66f7dd5814"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "96677a1b8c156c59a5dafd54c71452b39aa634cc5a79a38dd1923ef3439cd9c4"
    sha256 cellar: :any,                 arm64_sonoma:  "ae11e914c0646b015a44f0817bf1941d9184d187e8a6b0d9a27a745c1d6dd3e9"
    sha256 cellar: :any,                 arm64_ventura: "4967080886a07768bbc59a3bc887dca9da2b5838acf2d90a57794d651263c306"
    sha256 cellar: :any,                 sonoma:        "0fc57ff58fd2de88c62287da5943dc99ae207a06396b29f0c7a55e28eb9c1843"
    sha256 cellar: :any,                 ventura:       "d1390912755038a4a1bb52312eac2ab63bfb473705cb73f586afa424aa5ab23d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33cc26ffdbed851bb97a78bc459b3984dfd2d403d3ad7cced48998b0bfc55b71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1fda7012d00cf419f2fa149fbd05c8d6ec2b5d6b92d6a8348725c58484190d7"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
  depends_on "wangle" => :build
  depends_on "boost"
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

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

    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    linker_flags = %w[-undefined dynamic_lookup -dead_strip_dylibs]
    linker_flags << "-ld_classic" if OS.mac? && MacOS.version == :ventura
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,#{linker_flags.join(",")}" if OS.mac?

    system "cmake", "-S", ".", "-B", "_build", *shared_args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
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
    CPP

    system ENV.cxx, "-std=c++17", "-I#{include}", "test.cc",
                    "-L#{lib}", "-L#{Formula["folly"].opt_lib}",
                    "-L#{Formula["boost"].opt_lib}", "-L#{Formula["glog"].opt_lib}", "-L#{Formula["fmt"].opt_lib}",
                    "-ledencommon_utils", "-lfolly", "-lfmt", "-lboost_context", "-lglog", "-o", "test"
    assert_match "ruby", shell_output("./test #{Process.pid}")
  end
end
