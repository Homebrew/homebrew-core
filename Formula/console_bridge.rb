class ConsoleBridge < Formula
  desc "Robot Operating System-independent package for logging"
  homepage "https://wiki.ros.org/console_bridge/"
  url "https://github.com/ros/console_bridge/archive/0.4.4.tar.gz"
  sha256 "1147af6ad6477fcfd640c543684e17ee540e434aa70d6f31c1d137bc86fb937c"

  bottle do
    cellar :any
    sha256 "b2fd82467db6b32d1c5cc55cbd9315ec80ca4eaac464a4d42df284406056c691" => :catalina
    sha256 "7308ed00a95eb83e3abdb0f703e087233bd3a784ff346c04f722711e7cf479ce" => :mojave
    sha256 "e6db9b8748f57fc7e3e1ac8aabbc2b5e2fd90cc32c7430cf8da1bb4080457c30" => :high_sierra
    sha256 "758bcbd74e20a5917c1e167579561919cb6aa8cb1a2a184d4c223319c919d9d4" => :sierra
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
