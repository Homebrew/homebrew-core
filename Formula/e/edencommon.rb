class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2024.05.06.00.tar.gz"
  sha256 "02238f2a05e46f8189bf6826057b642f7aa03bd36684a245a900f8b6dc4afb7e"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c771c585c2a1e3cb9b103d5e76a5b966f4e9853e0fe1848802045a649842675e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ff98de9486f2b4ced0ff22462174b3c1e432ad2591131c54c2f30e1cd3fba7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21df80b27e291727526e56af8790c17bdb0e6014f5ab912df08b94de644c4240"
    sha256 cellar: :any_skip_relocation, sonoma:         "31c147866ed88c9c255388df30e98bdb51fdd751f66969144bc6126875fda645"
    sha256 cellar: :any_skip_relocation, ventura:        "9710ef8c8333c550e336534334dbbe49b8c9d97228472bb120aefb85db1eb7f8"
    sha256 cellar: :any_skip_relocation, monterey:       "3c8024ee66630dcb24dfa3b9a4ecac76626fd27cb82aa3fd54b9c54adb0be9a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b278be62c5d7bad5192909a6af245164c6dae126a656a5bf76531ed7b097e785"
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
