class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "http://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/libcec-4.0.0-2.tar.gz"
  sha256 "1caf0aac3b15971e7458f086a68077270253bfab4e721387d696eb200213f29e"

  bottle do
    cellar :any
    sha256 "9e4b3d9723bf4fc10a2f8e40a5261d66ac2a790df4adc490bf821382fbf08b45" => :sierra
    sha256 "7b3bf03c4bc3204caed287f5411488b0eeb98c137f96f5d3a9ce9f393b5cd6e1" => :el_capitan
    sha256 "2a556960b253734373427114391a1f4caa5b34f822c991b8ce85969bf469cc5e" => :yosemite
  end

  depends_on "cmake" => :build

  needs :cxx11

  resource "p8-platform" do
    url "https://github.com/Pulse-Eight/platform/archive/p8-platform-2.1.0.1.tar.gz"
    sha256 "064f8d2c358895c7e0bea9ae956f8d46f3f057772cb97f2743a11d478a0f68a0"
  end

  def install
    ENV.cxx11

    resource("p8-platform").stage do
      mkdir "build" do
        system "cmake", "..", *std_cmake_args
        system "make"
        system "make", "install"
      end
    end

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/cec-client", "--info"
  end
end
