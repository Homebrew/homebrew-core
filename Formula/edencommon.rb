class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2022.10.17.00.tar.gz"
  sha256 "3d73bc64f2700babeac3b4220ab9c1c2dff57af58dbc843bbabfeb2e768b7997"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "65f16fe42982cc8fd3959c03f7df654e61376eb5665ebcbcbc9e8ff546057051"
    sha256 cellar: :any,                 arm64_big_sur:  "2346cd0ff25b59a8a9c4b9c3da366708a49d16c81ddf4f95fe8c6a0644d763df"
    sha256 cellar: :any,                 monterey:       "5717f2d5a005aa3bbc1a4bde72910843a3bbb024347e4267cd486305dc9a9eb7"
    sha256 cellar: :any,                 big_sur:        "860fc93a500874de529227393edcbe0de7a4336aa1c30199a3d9573dda39aa69"
    sha256 cellar: :any,                 catalina:       "222f01cce1ee9a0c814245485c12b51282193d1a86b798010e96d13ab809a539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c3a15871387dcf0f7d2330a7253fa25f3094e343e62113e7caa56a4575297e0"
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
