class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  license "MIT"
  revision 1
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  # Remove stable block when patch is no longer needed.
  stable do
    url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2025.03.10.00.tar.gz"
    sha256 "11339514e6e55f962bd364ed6885479905638cd4a825c49e81d24a7fdaf0586a"

    # Fix build failure. Remove at next release.
    # https://github.com/facebookexperimental/edencommon/pull/23
    patch do
      url "https://github.com/facebookexperimental/edencommon/commit/917bc45667f136375c195150f8f6ded3ec7642f1.patch?full_index=1"
      sha256 "10f853b37f4a6deb9a46039e76e5b7a9e77362581d18cbe630536f1586eb9c6f"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "de209006a58b0c32712316f2026b7fd23f212eb94eae15525e379e869de39de8"
    sha256 cellar: :any,                 arm64_sonoma:  "3a2f6e1cc8f96cdd64a59a41bb74713a9a5d1927b6ddaa40d180959156e864a8"
    sha256 cellar: :any,                 arm64_ventura: "20eb4390228fa14cc4a5c308b3f1d247283ff738611391fb28c4f5dd53983163"
    sha256 cellar: :any,                 sonoma:        "33e83e3c4ded728294987118d282f9d280742efb3da147983e07fba6e91f0131"
    sha256 cellar: :any,                 ventura:       "95567fc4f9024bdffb5a86f9eb2bd31df6aaab37b615b5b40924eaa6ba3c3603"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb5de9958bd1e015d05dfefc8e89cbe32e0b38edea961607bbdf9dd69fe9dbaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c941c82dadc6db6b89f84c4934ee2dd75933e32d466b80d39d59d2546d792441"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
  depends_on "wangle" => :build
  depends_on "boost"
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

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
    (testpath/"test.cc").write <<~CPP
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
    CPP

    system ENV.cxx, "-std=c++17", "-I#{include}", "test.cc",
                    "-L#{lib}", "-L#{Formula["folly"].opt_lib}",
                    "-L#{Formula["boost"].opt_lib}", "-L#{Formula["glog"].opt_lib}", "-L#{Formula["fmt"].opt_lib}",
                    "-ledencommon_utils", "-lfolly", "-lfmt", "-lboost_context", "-lglog", "-o", "test"
    assert_match "ruby", shell_output("./test #{Process.pid}")
  end
end
