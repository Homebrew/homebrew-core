class ConsoleBridge < Formula
  desc "Robot Operating System-independent package for logging"
  homepage "https://wiki.ros.org/console_bridge/"
  url "https://github.com/ros/console_bridge/archive/0.4.0.tar.gz"
  sha256 "c78f87a05c1b2f299c0c8cc1aa9e0234c7e761aa521e4223ecf7aebd21874437"

  bottle do
    cellar :any
    sha256 "e20a0552bba0038ff4d9ec1d48a389c119949154f562e42611a09e2d6e38ee87" => :mojave
    sha256 "e58f4cb5a2e01bd7c014e7bc96b83046bce93bbf3f6664dc51820a49bfc2b012" => :high_sierra
    sha256 "3dd9b0b3f0171241bf9dea73bd958788f240f51c394b3e7268b677e0df86e962" => :sierra
    sha256 "adaf8ded297007d29b83556a470fdb24993d56df90defa75dab2a7a32a224c2a" => :el_capitan
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
