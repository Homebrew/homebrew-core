class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2022.10.10.00.tar.gz"
  sha256 "ef3d00e86fe502ad25d7cd560af6d7b2744ffb91e5c9d8ad63f57da787cda4fd"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "26c216c6ac767a1c375e0628f308fddda47cdfd74a2541bd4d3414bf74d039f3"
    sha256 cellar: :any,                 arm64_big_sur:  "b8ce2fe2b11704dc94755e111a0661ab093dde5b71b9dc275701bea4ac15e3b7"
    sha256 cellar: :any,                 monterey:       "9d84be36d7c4ac1ae077fa732233e86fc2e11ef3511c0a31df3bac55d3827867"
    sha256 cellar: :any,                 big_sur:        "7cb5bb9ab26431ae81b5d343b53e4787a5b15a5a827417b8cf0c5563608f01db"
    sha256 cellar: :any,                 catalina:       "0587ec366afbafb7ea93e42ff9208f8c94b3aeafa254203bdb6619502ac7ef45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecb93a06baed0e0385f97c683fc9665f082f6599f9c14ec1fb453ec8b216b51c"
  end

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
