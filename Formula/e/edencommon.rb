class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2024.04.15.00.tar.gz"
  sha256 "aeea5ad8fcae5e34940464c06703c6822917178a37f5021c4567a24f3d570a4a"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5ede45f5d12cd8103551c790fea6a4db9c11a41c1aaafd253697d531d524d907"
    sha256 cellar: :any,                 arm64_ventura:  "ab39df13e88c867de9c28cd8f3c26e135d38dad75d0400907cbb7a4c8311f873"
    sha256 cellar: :any,                 arm64_monterey: "f53ac50b48e67672dd1f6c349a77f479a6c508a6ce10196732bfc2297ae99c34"
    sha256 cellar: :any,                 sonoma:         "3573199b3f095623d0492a5f8bf99301c35e930a79d8982927357740b03f7cc2"
    sha256 cellar: :any,                 ventura:        "f31e48b61ac620c018fce5b65da0c68dea4baf2bebad5c368631ddfe0022971e"
    sha256 cellar: :any,                 monterey:       "bceda50640b2959637de3906d0a8660de5e4e15c4ddb131808ec2bbbc7df86ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c841a2419ab9999201fba5307e3a62d5f427b1187857f3ebd1572330686850d5"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "wangle"

  # Use AUR's patch from open PR to fix build with `fmt` v10.
  # PR ref: https://github.com/facebookexperimental/edencommon/pull/17
  patch do
    url "https://github.com/facebookexperimental/edencommon/commit/bd46378b43aaa394094799d18f734495385c6f67.patch?full_index=1"
    sha256 "74b47722dd7d40cb07fc504e9f14dd18fe6ee7c38b83373a4d94637fcb618ca1"
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

    system "cmake", "-S", ".", "-B", "_build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
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
