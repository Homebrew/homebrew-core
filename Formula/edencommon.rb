class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2022.11.14.00.tar.gz"
  sha256 "6f9321bf91703c0ca2b3627bd51a5a6b79bcd32f5aab487fe23f933864d0149f"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3307120f09bb0974e1f1a2c743a15d39067a81487349ce67c0ff10c8aa21955d"
    sha256 cellar: :any,                 arm64_monterey: "71d66559de0a1a1a043b2bed4bcf830a8308ed169b8fb5ae5139141c9ceed929"
    sha256 cellar: :any,                 arm64_big_sur:  "ea91a6028bea07d3c7081f5f7f74b9be40525cf7c339586f29fd37a2b44587a1"
    sha256 cellar: :any,                 ventura:        "e4dc73fca31044f7e248861107565a9e130962def20fbf2f6451a0739406add6"
    sha256 cellar: :any,                 monterey:       "8c34055e8f516839915b0eb185c221a5af028f5e14ed8117e2de7ba26dcc68fd"
    sha256 cellar: :any,                 big_sur:        "eb655a558fa8e01cda2bd9598777867cae5d036858e97ed875485a9d67e3fdc8"
    sha256 cellar: :any,                 catalina:       "63dc0acfb3bac452366deec041e826f10f8444da27c6365efd5628e366170b10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52b69f273ab938a6c160a758540f1815483d9933528359df0e7bd550b9192e41"
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
