class ConsoleBridge < Formula
  desc "Robot Operating System-independent package for logging"
  homepage "https://wiki.ros.org/console_bridge/"
  url "https://github.com/ros/console_bridge/archive/1.0.1.tar.gz"
  sha256 "2ff175a9bb2b1849f12a6bf972ce7e4313d543a2bbc83b60fdae7db6e0ba353f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "def9d47faffa3ced59e086013fd3677c765eddccecae200df4cd8b44911aeda0"
    sha256 cellar: :any,                 arm64_big_sur:  "2de26293b962e5fd45cf7d33e3d867ec5f3e44248736594f668993cab66cd642"
    sha256 cellar: :any,                 monterey:       "a585e971c0393f5460f204f03f31e6fef9f4068cd075503a402c8e6c7f513399"
    sha256 cellar: :any,                 big_sur:        "c9f53becfc647527e7044c1419bf992936c825920bd27637b8d4cbe07a675f9c"
    sha256 cellar: :any,                 catalina:       "0b499b94d9a1f14aebdbcdbfb21d95ce06a9c2a9160ecf317541bef7c76a1324"
    sha256 cellar: :any,                 mojave:         "a8fe261af6240d0a5128c4a9d214457bc0f0d20b198172c8a84e95d9ffa3fbd9"
    sha256 cellar: :any,                 high_sierra:    "0be0e4bb4c6a14c7f8725dc44443b5772e4b4a5b9da1df521cfb4d18d88c9437"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46bbb8159d744a618988624b1eb93b012852230b8347cafabb2f2c14c4ad8caa"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <console_bridge/console.h>
      int main() {
        CONSOLE_BRIDGE_logDebug("Testing Log");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lconsole_bridge", "-std=c++11",
                    "-o", "test"
    system "./test"
  end
end
