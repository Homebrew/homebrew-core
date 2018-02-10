class ConsoleBridge < Formula
  desc "ROS-independent package for logging"
  homepage "https://wiki.ros.org/console_bridge"
  url "https://github.com/ros/console_bridge/archive/0.3.2.tar.gz"
  sha256 "fd12e48c672cb9c5d516d90429c4a7ad605859583fc23d98258c3fa7a12d89f4"

  depends_on "cmake" => :build

  needs :cxx11

  def install
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
    system ENV.cxx11, "test.cpp", "-L#{lib}", "-lconsole_bridge", "-lc++",
                      "-std=c++11", "-o", "test"
    system "./test"
  end
end
