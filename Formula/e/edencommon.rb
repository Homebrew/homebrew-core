class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2026.03.09.00.tar.gz"
  sha256 "e90d7d94d06e4f7a87cfddd0ebf747c5b4a20112e7798c72873c583b282d15d7"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "3457fda00d252e4dbdeafdec1f782375a0adacb947182447894ccedc500efaf5"
    sha256                               arm64_sequoia: "a4024dd67590b9e510533c1e9749e8ef03726e82e045240e07981a9bf9f9fcdc"
    sha256                               arm64_sonoma:  "95544bfea1f6dbaca0b99e6d7d152d49b7edb08e8d064020464ec721b9370911"
    sha256 cellar: :any,                 sonoma:        "4be7fa60f0a9e6edcb68df7fb2268ebb448548f1a79f5e7a9e08bf980e14b099"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cf9c744dc53a8df3489c72f218afc5f45ef95f4489f462feed6a2cc25ef3ea3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8982437f130e543d72b2c86aed9cbaa691e62d7061a0b17c48eb8ced05753de"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift" => :build
  depends_on "gflags" => :build
  depends_on "glog" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
  depends_on "wangle" => :build
  depends_on "boost"
  depends_on "fb303"
  depends_on "fmt"
  depends_on "folly"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    # Related: https://gitlab.kitware.com/cmake/cmake/-/issues/26773
    test_cmakelists = %w[
      eden/common/os/test/CMakeLists.txt
      eden/common/utils/test/CMakeLists.txt
    ]
    inreplace test_cmakelists, /(gtest_discover_tests\(.*)\)/, "\\1 DISCOVERY_TIMEOUT 60)"

    # Avoid having to build FBThrift py library
    inreplace "CMakeLists.txt", "COMPONENTS cpp2 py)", "COMPONENTS cpp2)"

    shared_args = %W[
      -DCMAKE_CXX_STANDARD=20
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup -Wl,-dead_strip_dylibs" if OS.mac?

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
