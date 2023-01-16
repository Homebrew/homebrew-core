class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.01.16.00.tar.gz"
  sha256 "bf84041cd4798fa5aef7bd915ad65e7af0a01cde214b822e443a341c9cbbc8d5"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0202992afbb44f7fd82ba25a13439cecdc2af35edadc82bfe6945a39dc722923"
    sha256 cellar: :any,                 arm64_monterey: "608ad84c39210ca81c41c7db35c5446aa3c888d065319061d545fffac773c015"
    sha256 cellar: :any,                 arm64_big_sur:  "25b814fced4a11ecff1c875ad6ca98fe3a222c2c95b11e7a86d097dd99bd324c"
    sha256 cellar: :any,                 ventura:        "8ed3b4be88f4b3f346715fd71325d545fa44ced562e9cdb28554e66fe4f792ff"
    sha256 cellar: :any,                 monterey:       "bd52daece3de90f855fa17935fcee2278dd184c179c4bf6aefd0826d4f3c0b99"
    sha256 cellar: :any,                 big_sur:        "d174bf9a25958bf1a08181df3986b1fea4aadbd597043a10adaaaa3a2610db9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ced343e3dd7ec3dd9a8c92d76623e48b60578a32013e554191454edaa5cacb55"
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
