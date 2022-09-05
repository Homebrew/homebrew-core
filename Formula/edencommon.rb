class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2022.09.05.00.tar.gz"
  sha256 "d7c856ec21b0630ed48c6714c5b8e692f10d8d027554b11aa0c3117d84a2c318"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"

  def install
    system "cmake", "-S", ".", "-B", "_build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"

    system "cmake", "-S", ".", "-B", "_build_static", *std_cmake_args
    system "cmake", "--build", "_build_static"
    lib.install "_build_static/eden/common/utils/libedencommon_utils.a"
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

    system ENV.cxx, "-std=c++17", "-I#{include}", "test.cc", "-L#{lib}", "-ledencommon_utils", "-o", "test"
    assert_match "ruby", shell_output("./test #{Process.pid}")
  end
end
