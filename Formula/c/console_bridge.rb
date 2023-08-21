class ConsoleBridge < Formula
  desc "Robot Operating System-independent package for logging"
  homepage "https://wiki.ros.org/console_bridge/"
  url "https://github.com/ros/console_bridge/archive/1.0.2.tar.gz"
  sha256 "303a619c01a9e14a3c82eb9762b8a428ef5311a6d46353872ab9a904358be4a4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e4e12d390436e00eeaeda56b85f5f575dc89f8f9f412b39e59f42f34b4c66610"
    sha256 cellar: :any,                 arm64_monterey: "1b5e67f0fda0825deb5642b40c0b980ee38f04125c6b312e4d64a4c9e80c9f5e"
    sha256 cellar: :any,                 arm64_big_sur:  "c5518eeec5ec1bbf97b9079e07fdd9723521f9db974f000f86f2857160d35ffd"
    sha256 cellar: :any,                 ventura:        "65e60c19d1083cde663749983a1555e7389fba22756e97dd06adbc6ae7e520d7"
    sha256 cellar: :any,                 monterey:       "0e109671b38bf1d36b7e42250c2510a262452b97bc97a0a4d8ecd9c151c41182"
    sha256 cellar: :any,                 big_sur:        "8baf855a418a19417acc6ede52912bb003c5108b782fcf9bc29402b21c6b09a7"
    sha256 cellar: :any,                 catalina:       "7bedc8fd46f9d2a3404e3736e7231a5e303f9418b9a73354ee09d60ee233e644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2beccdecabf5d8427ee97904c16ff9f0aa2fc7bb508971ebbe10c5b1b9a2389"
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
