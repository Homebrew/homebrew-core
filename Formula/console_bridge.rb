class ConsoleBridge < Formula
  desc "Robot Operating System-independent package for logging"
  homepage "https://wiki.ros.org/console_bridge/"
  url "https://github.com/ros/console_bridge/archive/0.4.3.tar.gz"
  sha256 "9f024a38f0947ed9fa67f58829980c2d90d84740e6de20d75cb00866f07a7a0b"

  bottle do
    cellar :any
    sha256 "6cfc06d8ae110d740f208b162127d4e0a2cabf479ece89b8e80cdeb4246596f5" => :mojave
    sha256 "db387172475ff9b2316e108c3948949a5772d15bd031f4cfdc2cbc78720ea737" => :high_sierra
    sha256 "1685e012b79d53b1797db76c370a1fb8e1e88eefc589d79cc09a67e834552aaf" => :sierra
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
