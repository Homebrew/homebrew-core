class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2024.04.29.00.tar.gz"
  sha256 "4aa2299b0dc2de5841826c7b903521dffa4c528f689e4db91110fded71f93fc9"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36929e5b3b183e238e0180e3107c27f8030ff16dd55391a1463fd6bc73173b11"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44afb28b397e271aef582abcdda11ded217abf53e08d3121e8f66cfc50d604fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3239ba1e660130ac0f0844e4eb4980a0663d756d14c01b1a085b8a660ae7c4d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8ba57f094cf5f84240c5be5003b10b3ae685bda86f86934dd9ee876ec32407b"
    sha256 cellar: :any_skip_relocation, ventura:        "60ff02a4fc59ae54dc6be758da5cf964f6db2d25ef5057af81c6aedb7fa97bfd"
    sha256 cellar: :any_skip_relocation, monterey:       "592e2194c522b04c73e1f9dc65f51423ed3b3879d665a47446019ad35ba7ef10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4176b69eed7e4350b8a10a92cf9c75cf2ffc31913a10c7e4805abca3cc062e54"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "wangle"

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

    system "cmake", "-S", ".", "-B", "_build", *std_cmake_args
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
                    "-L#{Formula["boost"].opt_lib}", "-L#{Formula["glog"].opt_lib}", "-L#{Formula["fmt"].opt_lib}",
                    "-ledencommon_utils", "-lfolly", "-lfmt", "-lboost_context-mt", "-lglog", "-o", "test"
    assert_match "ruby", shell_output("./test #{Process.pid}")
  end
end
