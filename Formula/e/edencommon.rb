class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2026.08.03.00.tar.gz"
  sha256 "c9c4d0b7af41ff52de31c6e1aa1dbb62a7f6fcfdf058940ca1d4ef2edc3c5bec"
  license "MIT"
  compatibility_version 1
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256               arm64_tahoe:   "12225362d169f3500cc762e2f9a224d4dcf8ac3f4b03c6d9315143ba72fb354f"
    sha256               arm64_sequoia: "0feb7f6414e6b0103449d2b6a10690407669094f45b870cbef2b20c11317fbb4"
    sha256               arm64_sonoma:  "cc02614e068580fcd8234fe3ace6d008836e4321655f2336453d84b9a43f4099"
    sha256 cellar: :any, sonoma:        "ddafcc84b7d86a727f0c3a7977a3ee92e30e19e5ef6cffc8820301094b7922a0"
    sha256 cellar: :any, arm64_linux:   "6828f90b0d651ecd8a26b5a88ae24edb4079853acb3d95f077ff23745a94581e"
    sha256 cellar: :any, x86_64_linux:  "4ca46e69397424c7650fd3ec1fb2ef09649aeef1bdc85f8238c5b620ea8a2781"
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

  # GCC 13 libstdc++ no longer pulls in <string> via <string_view>.
  # PR ref: https://github.com/facebookexperimental/edencommon/pull/32
  patch do
    url "https://github.com/facebookexperimental/edencommon/commit/7dc082da238446cde535b03370be0b709701b7ac.patch?full_index=1"
    sha256 "1becb3b9bcba13f19cb697baa015bece72b0330e4beae6db5a459f4e6fbff5a5"
    type :unofficial
    resolves "https://github.com/facebookexperimental/edencommon/pull/32"
  end

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

    system ENV.cxx, "-std=c++20", "-I#{include}", "test.cc",
                    "-L#{lib}", "-L#{formula_opt_lib("folly")}",
                    "-L#{formula_opt_lib("boost")}", "-L#{formula_opt_lib("glog")}", "-L#{formula_opt_lib("fmt")}",
                    "-ledencommon_utils", "-lfolly", "-lfmt", "-lboost_context", "-lglog", "-o", "test"
    assert_match "ruby", shell_output("./test #{Process.pid}")
  end
end
