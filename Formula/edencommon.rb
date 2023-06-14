class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.06.12.00.tar.gz"
  sha256 "8cfd53508ba31a5a830987a7c99ecf2dc25541a76f82e836c260e6c53e4d793b"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "31eeefe481f072f6342438d962a98eabbd330b126d02632163d9e0cf8126fe14"
    sha256 cellar: :any,                 arm64_monterey: "3105ed75f724ef0ee6c0286b4645225b4aba2ef7431e69ce7069b3732475b9e9"
    sha256 cellar: :any,                 arm64_big_sur:  "54c1b56dd25b0c5060bde2bf3ecaffa3af310730dd7a56f673d5a714e90be75d"
    sha256 cellar: :any,                 ventura:        "bf56f78351cbab193f4d6e0b3da4904bd0cefdd27ad15fccf2ad5b3824814c43"
    sha256 cellar: :any,                 monterey:       "e9251d5c9b6727457950a6694f977636f505ed60485c8197805b9352692bff95"
    sha256 cellar: :any,                 big_sur:        "286b22c1daf965c254e1602dd4942f6fa659e1e3098315c532094c0e47e3ff8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7497f2829031156b37c882ebb691470dad60f1ac5ca1df45e1fa53f2a159c73"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"

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
