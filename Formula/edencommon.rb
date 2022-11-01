class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2022.10.31.00.tar.gz"
  sha256 "faaf945d2b61c72ba4240c1c37763d1e930731187bba8803332b14bda3d8f2c2"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d30db94d6955bf0bb776a9004bf67133f7275d64a19976c7a9aff45dc042342c"
    sha256 cellar: :any,                 arm64_big_sur:  "f2581dc980677ba6bccb6db447ed67a50c52c3d62d55f5157b90174fcc4d61c7"
    sha256 cellar: :any,                 monterey:       "c3e05cfb6b2746726ef1298177c7c66ccc53936b88600e15108d588d8860f115"
    sha256 cellar: :any,                 big_sur:        "fb3a4d4ced0af0a602d2de3e2345ab7b5ff1825ee1d084a20a1ffcabe836c619"
    sha256 cellar: :any,                 catalina:       "cdb326c8d7a700d6e7229d1847873aef474a82730a3a107dacea073e18fbb5cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02ce2ad96e8e68519388627251c6dd8b811a4a3bc19f49a13900c6e3bd5bc972"
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
