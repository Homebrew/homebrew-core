class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2026.11.23.00.tar.gz"
  sha256 "14bff4499e31970485524134961c0b6199ddcd4317f678320743e786df508506"
  license "MIT"
  compatibility_version 1
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    manifest_sha256 "5d7d90caf48d5c6052c988101246b92b9918947bd17824bddf10c9d54a92b70a"
    sha256 cellar: :any, arm64_golden_gate: "67749b8784681d70dc35f4138aea7e22aea91fc2075e540f1dc3b6ead21a34fc"
    sha256 cellar: :any, arm64_tahoe:       "ba69edd0b0c724d4dfd4cf7fcbb2985209f6bfaebb157f8b8e6061d9ce09da3e"
    sha256 cellar: :any, arm64_sequoia:     "8c0478b045b6b0cb00901a627e90d5c720ec63902d04eb0cd9d3e87ad5af2a1a"
    sha256 cellar: :any, arm64_linux:       "556a49357be8f056b58c58048a43d3a880cf478610c60b9cb0e308ef51165077"
    sha256 cellar: :any, x86_64_linux:      "fd12cd793a46baac41cf54bb51006bc908bacaad591882f4d81708c73814a015"
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

  deny_network_access!

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
