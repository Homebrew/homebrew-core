class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2024.07.15.00.tar.gz"
  sha256 "41457a68eed0d6b3cc4807de49b34be2c4631e98bbf5dc2f4286a38819fd183a"
  license "MIT"
  revision 1
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0d1ffc684a8db57c2dffd5099fd10cee036424ddfe09582a072f22be1f9683cd"
    sha256 cellar: :any,                 arm64_ventura:  "21789c6a8ed3a7f5c885f96683a17cbb1e64d3c8ce1abcb01de2b6a3920d22e4"
    sha256 cellar: :any,                 arm64_monterey: "99e64f9ca54eed8d65c1fdad883c93a067bcce9daa6cad91483de0a728a686cf"
    sha256 cellar: :any,                 sonoma:         "f7d67a416d26955c985630386f930b87406d8238a408bbb4855d1fd295053ade"
    sha256 cellar: :any,                 ventura:        "b75bcc234843e179c51090087d4092913c71e2d35d96dd48107b227d44a26f64"
    sha256 cellar: :any,                 monterey:       "5818fdcddba06a900bb18068566aa0f14d3dbe6ac0f7cf511205a244c0f732d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c057ccd6ac3884681787293d97ce7c17721f6fccb7d403fe66d810c95b3a06e6"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "wangle" => :build
  depends_on "boost"
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  # Build shared libraries
  # https://github.com/facebookexperimental/edencommon/pull/20
  patch do
    url "https://github.com/facebookexperimental/edencommon/commit/01bca703032ff108665a83274fb56617b46882aa.patch?full_index=1"
    sha256 "50f704ad44aa6fa8df35d913966c5c28f8fddb8871b35b3420875c804efc386a"
  end

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace buildpath.glob("eden/common/{os,utils}/test/CMakeLists.txt"),
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"
    inreplace "eden/common/utils/test/CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

    # Avoid having to build FBThrift py library
    inreplace "CMakeLists.txt", "COMPONENTS cpp2 py)", "COMPONENTS cpp2)"

    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    linker_flags = %w[-undefined dynamic_lookup -dead_strip_dylibs]
    linker_flags << "-ld_classic" if OS.mac? && MacOS.version == :ventura
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,#{linker_flags.join(",")}" if OS.mac?

    system "cmake", "-S", ".", "-B", "_build", *shared_args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <eden/common/utils/ProcessInfo.h>
      #include <cstdlib>
      #include <iostream>

      using namespace facebook::eden;

      int main(int argc, char **argv) {
        if (argc <= 1) return 1;
        int pid = std::atoi(argv[1]);
        std::cout << readProcessName(pid) << std::endl;
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++17", "-I#{include}", "test.cc",
                    "-L#{lib}", "-L#{Formula["folly"].opt_lib}",
                    "-L#{Formula["boost"].opt_lib}", "-L#{Formula["glog"].opt_lib}", "-L#{Formula["fmt"].opt_lib}",
                    "-ledencommon_utils", "-lfolly", "-lfmt", "-lboost_context-mt", "-lglog", "-o", "test"
    assert_match "ruby", shell_output("./test #{Process.pid}")
  end
end
