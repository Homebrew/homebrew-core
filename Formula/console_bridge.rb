class ConsoleBridge < Formula
  desc "Robot Operating System-independent package for logging"
  homepage "https://wiki.ros.org/console_bridge/"
  url "https://github.com/ros/console_bridge/archive/0.3.2.tar.gz"
  sha256 "fd12e48c672cb9c5d516d90429c4a7ad605859583fc23d98258c3fa7a12d89f4"

  bottle do
    cellar :any
    sha256 "dc5ba07f8af3c710d8a86536801d0770fb1755c9b32706b26bfe52b46c65f264" => :high_sierra
    sha256 "31b0c5dae6dff5f796c3752e636cdf2fbbd4bc16d47288c06809668fde424dd0" => :sierra
    sha256 "bbc636adfa1c9a7322c9eb9646e228d85b0a9c3802d6c9d46f90f34be8cb268e" => :el_capitan
  end

  depends_on "cmake" => :build

  needs :cxx11

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
