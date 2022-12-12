class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2022.12.12.00.tar.gz"
  sha256 "23fb00c98882b104141459f8efe1f372dc0442ec8d02ec844e3839c1b87beb29"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6d9c954bc2e4ff6abf196ac3c32703ecd345a39df5c55f63e847f032cdec23b2"
    sha256 cellar: :any,                 arm64_monterey: "d40b0769ac84f8b5f98c3ffcb3068cdd7131277d00966c0b90300d234f8f65e0"
    sha256 cellar: :any,                 arm64_big_sur:  "0a14e82eeeb56921b6aa5f747378a5c7bf653b77266753354b5a9038b0adfa87"
    sha256 cellar: :any,                 ventura:        "5aac78bb1bd49d54d4604c82df134a67644b4128a45a3d6278a5f471a6b944bf"
    sha256 cellar: :any,                 monterey:       "7a1c8b840f0510aea95232a2fad1bef02203c7eebd74741f29cb2d159b11775c"
    sha256 cellar: :any,                 big_sur:        "abca5ced8f69bfba66f1e52eaa0662b06b3fb39c8903e13b4d3bdb2020cff87a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfafc7715e3a937801567e3ab2b07de303520893af6dbe0abc473176343f07ef"
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
