class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.09.04.00.tar.gz"
  sha256 "d42f71d2e3f334d1a0797922abe04b16a1bd0b2c7914bf5c8c801d8a7538f9e5"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "929497e7f932878f26faca065ec1a643106ce94b27af61cd74c503c7c04a087b"
    sha256 cellar: :any,                 arm64_monterey: "c0ff5be350922c9d6769f6864dc3dc8b626a4bb0c89e15e13b3390b3ce2f597a"
    sha256 cellar: :any,                 arm64_big_sur:  "9e4005f74df987ababecb953d2c5c9aa2d1cc2884d1aa69bc9253f3270e4439f"
    sha256 cellar: :any,                 ventura:        "b1e5887ef2d752abc97adcb43f29400b0f6b7c8e872d7de668ee5bb9ae1b87c6"
    sha256 cellar: :any,                 monterey:       "9cdc228b3b2c6969d90287a5919d9a48770b958da3e429b4f7a20a4230b8ab5c"
    sha256 cellar: :any,                 big_sur:        "3b50778f30e5782b0b52b21cf415fb12d5e5c69092efa1a2cf86c21ffc1632d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93a6f7462557652a9c4467b28cd83e907eb1c9d2427db039e7dd043aebd356a0"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  # Fix linkage against folly
  # https://github.com/facebookexperimental/edencommon/pull/10
  patch do
    url "https://github.com/facebookexperimental/edencommon/commit/b162c1b8d94b4ed49835da6d03b4d0a550082b47.patch?full_index=1"
    sha256 "99c299fa6df887d1e72aed3d60a8ca32eb2eda1897715482af8ddfa4702fe24c"
  end

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace "eden/common/utils/test/CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

    system "cmake", "-S", ".", "-B", "_build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <eden/common/utils/ProcessNameCache.h>
      #include <cstdlib>
      #include <iostream>

      using namespace facebook::eden;

      ProcessNameCache& getProcessNameCache() {
        static auto* pnc = new ProcessNameCache;
        return *pnc;
      }

      ProcessNameHandle lookupProcessName(pid_t pid) {
        return getProcessNameCache().lookup(pid);
      }

      int main(int argc, char **argv) {
        if (argc <= 1) return 1;
        int pid = std::atoi(argv[1]);
        std::cout << lookupProcessName(pid).get() << std::endl;
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
