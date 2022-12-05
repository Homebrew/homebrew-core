class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2022.12.05.00.tar.gz"
  sha256 "690e81d5e0c5671823a7af7e57522db68ac53995439b7c789c39f823e6c2fb23"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "278de3dc15b1f8900836453efe6d527dc76252acad02291edce43e963ffce722"
    sha256 cellar: :any,                 arm64_monterey: "34480e072c491e8c1b5955f44a01ffdc29c19817030dac5117bd09219e49df0a"
    sha256 cellar: :any,                 arm64_big_sur:  "36655b49545b901749fb768f1e7abebfab923faa79e3fe48b5ceee5da527b3c2"
    sha256 cellar: :any,                 ventura:        "b03d8da73d974d9a21d182f565bda05e9e1f2bc4bfe3b39bf582c98f6bdeccda"
    sha256 cellar: :any,                 monterey:       "9ac9aa0ad12c6e712303d32a3b89413e4d355305372b6e55dc9a27309265c449"
    sha256 cellar: :any,                 big_sur:        "16b9171703837393e18c4dce7b03dc87505ae4309f7bfe0182ded9529eabe5dd"
    sha256 cellar: :any,                 catalina:       "5fa0a69f6b2098b70abdf8dcec21136fc89881c46fd281f452334f9a5e095f06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc636c211af03eb90f22265f5401d838b3a831dc8b4d4d566cd5093e13b10806"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"

  def install
    system "cmake", "-S", ".", "-B", "_build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    # Workaround for `Process terminated due to timeout`
    ENV.deparallelize { system "cmake", "--build", "_build" }
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
