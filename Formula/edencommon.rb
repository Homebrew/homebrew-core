class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.06.26.00.tar.gz"
  sha256 "0b6987a55c7c57a2b22fa40ffcbcafe4421a0fb9bb1bc0b38d6f7df731f1921f"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5dd313a6103c0cd023441cf7f99e4ef8285f3f54b3b2db74ec6666b09402daab"
    sha256 cellar: :any,                 arm64_monterey: "39165ef97161cc9f123719ac6721272b7f642b334d281d42d56f304996bba1a2"
    sha256 cellar: :any,                 arm64_big_sur:  "17cf0589c46946978f03905f8f79eee73ed38fb54a326b89c410e4f0c9ad7e93"
    sha256 cellar: :any,                 ventura:        "5c0f1913a6d1c2646eb1047382eca968d788eed3028d7f6fbe6096c54677d4d3"
    sha256 cellar: :any,                 monterey:       "717f62779803a7a14ba43b2c82eb1cfcd805c957fe5df094f69f99f2f40b51b7"
    sha256 cellar: :any,                 big_sur:        "fb7b7738a74e98a9366c693984df05aa61376ddc1aee9c8443f2e4b548986e58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7267cce265cbea5b961e084ae787d8c58967808fea105d5d7d2a3b06d5645d2"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace "eden/common/utils/test/CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 30)"

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
