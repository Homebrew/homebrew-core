class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2022.11.07.00.tar.gz"
  sha256 "d28a0dd18e41a375a8127836aa884b3efdf95ff296f61cf6b8c4f16107502057"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "829febd480e5b613633bb3c12d4d690bb887bd39de3d3d73faf62c2cd568678e"
    sha256 cellar: :any,                 arm64_monterey: "589f6f9a97be941f645aa6777840aa75877a4ff8dcad5ade883595efde3cdb4f"
    sha256 cellar: :any,                 arm64_big_sur:  "9835260b36b4aeb2b3459f127b36f9af4f8e654e6ad074f36f6edabe0be5da51"
    sha256 cellar: :any,                 monterey:       "865162f1cb21d7e1cafb2e9b2033e4b8a858030694e1eae2ff6b6dbd9b18dbf8"
    sha256 cellar: :any,                 big_sur:        "d579a9d0659e5dedbd3593e990726bf384d854ededc0929c47dd82e7fc474df2"
    sha256 cellar: :any,                 catalina:       "0dcd8447df8275ca18cf727ebdc74d86b420a751691fe334f2e2c62d4ac5a5e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "714f1e113eb684a70ae16ca52f1c70460298ec6a0d4e9d107d40b65bf5e7f3dc"
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
