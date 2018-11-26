class ConsoleBridge < Formula
  desc "Robot Operating System-independent package for logging"
  homepage "https://wiki.ros.org/console_bridge/"
  url "https://github.com/ros/console_bridge/archive/0.4.2.tar.gz"
  sha256 "f44641bed7268d72354476c8c5ff936f0e600e4170e1ff7f61a4b6e1f3fc20ff"

  bottle do
    cellar :any
    sha256 "0a126b31ab5574f73bc63c1631a926adcf7c2d8bfc9478446c632889a1774e86" => :mojave
    sha256 "d3436f9f52f53e1cd4d78b69d3b1eae604758a522c7dac2658058b9e9e7c7612" => :high_sierra
    sha256 "b1cf1ec57ccb4abb2ccce3b933fc7903c5acdfa4969289f46c39e40e880ede60" => :sierra
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
