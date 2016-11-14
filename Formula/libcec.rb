class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "http://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/libcec-4.0.0-3.tar.gz"
  sha256 "5c82a3f7075df35319bc223627f2decedb38a3322c621bb925f7807aa1e43d50"

  bottle do
    cellar :any
    sha256 "2cb2efcab785bde1fd30e7805ffd1638ac1f26c974232054edb0fd43e4970f7f" => :sierra
    sha256 "d01cd0647f2205833155cf111d4b9c6cca645fee70b238b473a14763676956a7" => :el_capitan
    sha256 "6727d43f63ba2a40883433d7a1f9fa0dca316291008be6488598d2b7e8856151" => :yosemite
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
