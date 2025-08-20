class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2025.08.11.00.tar.gz"
  sha256 "25b5bd103e6450fe8e357fb76544c2816f1db405bb302a6f9f7a9386b5eb2d52"
  license "MIT"
  revision 1
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "7b22e9fd04bbe5be75fb86809d97a48a1cce0e5939581424bfdb5589ae7adafa"
    sha256                               arm64_sonoma:  "99b3beb941b6548c8fc91501b2fbbb4c5ec18a101d63e5152c13adb2b742e9e0"
    sha256                               arm64_ventura: "bc0c0436e4fbce956da6267605d4d6bfc848d83c9bb3b5510825ec031f49c64c"
    sha256 cellar: :any,                 sonoma:        "16851869dec692175bdfb09a9fabd52aae28259ab1d0fe7c4314762a1d82a75c"
    sha256 cellar: :any,                 ventura:       "a3cb5f41d891f37dcc38b217b7c034b2efca3d6d9f694592e0cf948687c77965"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "074a5ed7d786dafeca9940b89e2ee0049d7332b3a3a3c79cee8e0fdabfeb69e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8035af26e4ea677ef029bcda5321ffe5b51084ad930ceede6e8182b3c0e1afe"
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
