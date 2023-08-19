class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.08.14.00.tar.gz"
  sha256 "ad85ff9049be423e14f339651daa6038f279cd9d0fb45d2d6c409f535f1b26f6"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ab3286ad4da992f26644863d8c27ccfcf35c04aab17a00e05393e944a69fc230"
    sha256 cellar: :any,                 arm64_monterey: "8f7a9ad5e0b5d2a31e000fb1118dea2d78bc3f38a23bfc223b4a6fc2738536dc"
    sha256 cellar: :any,                 arm64_big_sur:  "5da9dde8a240eb230a745728312d99dcfa61e9107ce809c566875a2f058a9872"
    sha256 cellar: :any,                 ventura:        "47d6777cce835040cf5c8ced731e9b2b5188643797effa198e70bf44c6d238bb"
    sha256 cellar: :any,                 monterey:       "6b2c924adeaf6f658560bac1062b0bd8329e77a0f6dc69ce0a4d9e1e5c0f544a"
    sha256 cellar: :any,                 big_sur:        "3541ff66c8e232fb2030ba6ff852f441ef58d97e2e197cb67a90a477d3b41156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b75bc8549324f5d166d8e6fdf20df1c1e4e76f3c6b98a6937f1638d02ea4970"
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
