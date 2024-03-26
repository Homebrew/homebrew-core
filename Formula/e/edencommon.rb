class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2024.03.25.00.tar.gz"
  sha256 "2de760cd9ba3409c7df2f5740cc88770e4ff9768cd4a6911fa4c81ff86d33417"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "de4f9d51fe8043c0a1c2396d3ef99eb169c3606ab4f6601c167988db0b2d914a"
    sha256 cellar: :any,                 arm64_ventura:  "cb2d3ad01ec86a2d3aace0479293543e6069aaa941aba5e49c2ee55027ee73ab"
    sha256 cellar: :any,                 arm64_monterey: "22576f5e1c9b6d475b64635b91c99bcf7ced2b36d1d7f3b5e4062a4a441b6084"
    sha256 cellar: :any,                 sonoma:         "620d99227a17be2d66791d37af4c0775eb0642b272a0e6040c33c04cb542f47d"
    sha256 cellar: :any,                 ventura:        "7c97fa33f6d02a03b120eab92ed49e42a1c2189ad084d0c5329aad8cf2a26e01"
    sha256 cellar: :any,                 monterey:       "e283385403bc4ba61515f52f35fb28c9fbe72af3df69739bfbb46988c19ed4b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccf79a6214d9aba6c71a2ed83486d5451fb7a35e17a1fcfae6a16ebcec964c30"
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
