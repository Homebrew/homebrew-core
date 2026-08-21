class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2026.07.27.00.tar.gz"
  sha256 "7be895a8d9a6eb88523488142503ce9b14d097b518967dd50b9c4cf7675c8080"
  license "MIT"
  revision 1
  compatibility_version 1
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256               arm64_tahoe:   "a383d39e667eddaf4e0e99aec0ea721c259a85a024825a37051ff494f6d8b494"
    sha256               arm64_sequoia: "4a467cb502c1c63b9ea93a41cfbb5023914d56b46b81fe794266045a7b4432c1"
    sha256               arm64_sonoma:  "191759e6fcee746840053a1905bd5aa5c86d49fe01879b42806fd1c500a8c7a9"
    sha256 cellar: :any, sonoma:        "f81229eb96a146cac1d15bc610b9e106d08d798e3d60fa6a936704e9f94e9cb7"
    sha256 cellar: :any, arm64_linux:   "502b1f1a25c311f44ff1e1a20ab3baa9cdb9c550a9b85a6eb0be5523b7926e93"
    sha256 cellar: :any, x86_64_linux:  "e5cabb86e645026ad23c8a0d83e9035aba08ca59494a81f1a3b0c0d187555147"
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
