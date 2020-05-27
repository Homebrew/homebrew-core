class ConsoleBridge < Formula
  desc "Robot Operating System-independent package for logging"
  homepage "https://wiki.ros.org/console_bridge/"
  url "https://github.com/ros/console_bridge/archive/1.0.0.tar.gz"
  sha256 "880bbded7fcdc71479e9b1efc3ba5353f08eed23f0009c93d6bea8ba3974d078"

  bottle do
    cellar :any
    sha256 "e98131216958db0f3933e7fee94f37d5e356e599802e828f06423930fae66412" => :catalina
    sha256 "f79326ff43c19d1fe5cb51af9728a52dd74953ab69c24712fcd8c7c1cc0586f0" => :mojave
    sha256 "f1bc8a6b2fd18aa320dec8239f0a2f2082518289fe29da765600e728fa9e2765" => :high_sierra
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
