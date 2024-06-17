class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2024.06.10.00.tar.gz"
  sha256 "2b3b749e0b4457f90f9ccd08d6bb49de4abeb38f29311f60cd2af689da4f4424"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "576532c7f759d573dfd79aa9df1cd4eca8f79f27365303c80ff27a052ba0bfb8"
    sha256 cellar: :any,                 arm64_ventura:  "b37cd23ba6c21329a1943a7ebf590377bb535e9ac9c6199c3bab8b1c13c2f220"
    sha256 cellar: :any,                 arm64_monterey: "dbe5b764e56a07cdd7634e610f733062cd38d2b53272c56deceb80e25fb0f27b"
    sha256 cellar: :any,                 sonoma:         "aea34913626958fb413ed794e9fd8d66f9d2924dbbb850fd9f2d2bcf89d40dff"
    sha256 cellar: :any,                 ventura:        "0ba1e0acf9c4ea9e259615f6af2af55cff7498f0d1511f08faf4dd608ba07262"
    sha256 cellar: :any,                 monterey:       "d6f326f95a1092b251a4f6bfdaa9b01a462d2a76275ef19d7db777b683de5cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60262972ed06598ea81c2d12ab1716e04ed86540a15f51d9a2b3927dfc9781d4"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "wangle" => :build
  depends_on "boost"
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  # Build shared libraries
  # https://github.com/facebookexperimental/edencommon/pull/20
  patch do
    url "https://github.com/facebookexperimental/edencommon/commit/01bca703032ff108665a83274fb56617b46882aa.patch?full_index=1"
    sha256 "50f704ad44aa6fa8df35d913966c5c28f8fddb8871b35b3420875c804efc386a"
  end

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
