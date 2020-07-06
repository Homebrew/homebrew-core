class ConsoleBridge < Formula
  desc "Robot Operating System-independent package for logging"
  homepage "https://wiki.ros.org/console_bridge/"
  url "https://github.com/ros/console_bridge/archive/1.0.0.tar.gz"
  sha256 "880bbded7fcdc71479e9b1efc3ba5353f08eed23f0009c93d6bea8ba3974d078"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "8d2a1fc160054eeb2a8e373599867ce8c02c2e1a9e6c4f6ca38e1108d328577f" => :catalina
    sha256 "61bbee506d4e6aced344f034fca587e56f0608bc75bf1b378fbecfd31e334a40" => :mojave
    sha256 "ec5140cfb22e4dd077bb5d2f15b8c4e5189205e00b235dee4e8574369f38f903" => :high_sierra
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
