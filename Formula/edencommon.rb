class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2022.10.03.00.tar.gz"
  sha256 "48354f0580ec8617cd12a52f4e58008a53bb468dd76aad64d7d8b62b4b7e7051"
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
