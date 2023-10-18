class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.10.09.00.tar.gz"
  sha256 "a677452673a9ae15eecc55585ab11db8d43f5a0d3707f4d91319ac5048665814"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5260a054fb2447401356fb3c3127f2d575ef7265e6d6d999cfb8203a0faa54d3"
    sha256 cellar: :any,                 arm64_ventura:  "8388d98401af120c9e6a2280d9b33d769ea769dcd06c3f03863638c74c1c4e1c"
    sha256 cellar: :any,                 arm64_monterey: "33b51156803951d031b633f49b3b1d3c90b09eb11cac68f8c359592be71f52e0"
    sha256 cellar: :any,                 sonoma:         "e0f4229f1da9b61a0d2d57dfc6a2a320438cf676eb1f00e032668ff8505ca1f8"
    sha256 cellar: :any,                 ventura:        "3e877246b06a0b559fb68bdc542041521b56e67a566439d5d72383bc653d8273"
    sha256 cellar: :any,                 monterey:       "6e1f7b76f7592c30a647055c1dc455a4f087f2afb8b8ec527d79a344a788a478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bc628f1469ab38c151aac07ab56cf2a5d4ae84754d2c663ce2e9ae9583615c1"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  # Fix linkage against folly
  # https://github.com/facebookexperimental/edencommon/pull/10
  patch do
    url "https://github.com/facebookexperimental/edencommon/commit/b162c1b8d94b4ed49835da6d03b4d0a550082b47.patch?full_index=1"
    sha256 "99c299fa6df887d1e72aed3d60a8ca32eb2eda1897715482af8ddfa4702fe24c"
  end

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace buildpath.glob("eden/common/{os,utils}/test/CMakeLists.txt"),
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"
    inreplace "eden/common/utils/test/CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

    system "cmake", "-S", ".", "-B", "_build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
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
                    "-L#{Formula["boost"].opt_lib}", "-L#{Formula["glog"].opt_lib}",
                    "-ledencommon_utils", "-lfolly", "-lboost_context-mt", "-lglog", "-o", "test"
    assert_match "ruby", shell_output("./test #{Process.pid}")
  end
end
