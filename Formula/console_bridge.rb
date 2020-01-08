class ConsoleBridge < Formula
  desc "Robot Operating System-independent package for logging"
  homepage "https://wiki.ros.org/console_bridge/"
  url "https://github.com/ros/console_bridge/archive/0.4.4.tar.gz"
  sha256 "1147af6ad6477fcfd640c543684e17ee540e434aa70d6f31c1d137bc86fb937c"

  bottle do
    cellar :any
    sha256 "3bb19cb882a45c902423f226a51638dc72db201589a7575c585e8239a41e009d" => :catalina
    sha256 "aea1327f4b80efdd3fc30396fd4fbb480220f9e685d93a83255806d468ea9ea0" => :mojave
    sha256 "64532f4b44e228941aca08681dbae1591f189b4d8c9ce7a26c80e1f6cadb3633" => :high_sierra
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
