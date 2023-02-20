class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.02.20.00.tar.gz"
  sha256 "ef384cf4f1c70e511461e55086e3db11a8069f9375374afdb65a05119f4c3d91"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0346db08ef7db70eea9fe5028f9f67b558264db4003ba893028c56b4fe71aa1b"
    sha256 cellar: :any,                 arm64_monterey: "f355af74c6e14fa5e631c037d1599d679a8470619e71ca881659257c94f3351d"
    sha256 cellar: :any,                 arm64_big_sur:  "f35cec9cc106867fd431c5132247939d9881dcb6856b29a0d6273f51553c689d"
    sha256 cellar: :any,                 ventura:        "036c0c0a84a9b14ded439445e011667fabd9a4b2c13b368dc3905c5ad12fba11"
    sha256 cellar: :any,                 monterey:       "2cef615d3a3460e680b1f9db1a9eb64db0f6e845dcb9e3e942507b5cadbbdf2e"
    sha256 cellar: :any,                 big_sur:        "b8a7ecc3d3fda4ae830ae0f617b34f45287e3f19a77e98a49ff09f72c42d4f7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52489271b6ff09790d57e2f20affd84ca9f348fe27e055abd38aca6c21cb3e5a"
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
