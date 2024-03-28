class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2024.03.25.00.tar.gz"
  sha256 "2de760cd9ba3409c7df2f5740cc88770e4ff9768cd4a6911fa4c81ff86d33417"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "88562b5759948c1821534eb27326596958e301042996251023e15620a9dd53a4"
    sha256 cellar: :any,                 arm64_ventura:  "d194e6e436fd5991df9c20a963fe96149344306cf9d1306cbfbe222fe03f031f"
    sha256 cellar: :any,                 arm64_monterey: "4334c4f1f895d472776eb22e2b5eb00a7eb9208e8e6cb54b215641dcd7a91ba5"
    sha256 cellar: :any,                 sonoma:         "189783f86919dc0abdeedaee692015baabdbcf3933537b61e69608b876cb36f9"
    sha256 cellar: :any,                 ventura:        "6aea14b62ca6e63f26e495e8da97c5c254115db08e51cf62b64442c594801fb8"
    sha256 cellar: :any,                 monterey:       "0589f728da66a86960aa2c5379d28ff6dcda064786918bd1aa28ff8e7f93f9f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76c77b000afb0f324cb495bea19cafbe909860802991ddebd6d31a8a657eedfa"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "wangle"

  # Use AUR's patch from open PR to fix build with `fmt` v10.
  # PR ref: https://github.com/facebookexperimental/edencommon/pull/17
  patch do
    url "https://github.com/facebookexperimental/edencommon/commit/bd46378b43aaa394094799d18f734495385c6f67.patch?full_index=1"
    sha256 "74b47722dd7d40cb07fc504e9f14dd18fe6ee7c38b83373a4d94637fcb618ca1"
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

    system "cmake", "-S", ".", "-B", "_build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
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
