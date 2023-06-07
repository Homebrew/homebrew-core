class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.05.22.00.tar.gz"
  sha256 "5475d55ed7dcae87b51c7f9581d69cf979ae7993ecdb09589b2059a8aa7f7356"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ad58e9a6314667bc29194f6f587d3d26800369f6ab288072aaaafc5d6adcc767"
    sha256 cellar: :any,                 arm64_monterey: "916db4a486c39a9bb021a180f66831a1542214e219967886845f62a3505d7c20"
    sha256 cellar: :any,                 arm64_big_sur:  "667782352149fa6a46b0635fe18d18bb7bcec486c9176ab804de6c7644650e30"
    sha256 cellar: :any,                 ventura:        "541240001ab542c478de42e92cae3cebe71fbd7c773298506aed6b37e54a7cbf"
    sha256 cellar: :any,                 monterey:       "940b9bb23c51d303eaa78fdbdf6aff0e8b6e13972e5db6a18dd9b92eade2241e"
    sha256 cellar: :any,                 big_sur:        "c75ecf457f2df595899597b07504a3d205f4e1157ec7fe55f47cdd00316c51dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fc9e6e39e0270b16f8d46897e393f589b5056ccfa3012a506bafea9f2592989"
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
