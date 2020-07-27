class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "http://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/libcec-6.0.2.tar.gz"
  sha256 "090696d7a4fb772d7acebbb06f91ab92e025531c7c91824046b9e4e71ecb3377"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "eef61bc6c5647a5b26f8949b53973e02ec44640d82ceff633183da7b20eac212" => :catalina
    sha256 "c64dda68a5e5d00d6867aff92b576a71b8550d7250bbe7f86d0c1a9b1b861613" => :mojave
    sha256 "2d7d295151c68aeaea3a269d66156b2d29f08a619d60079e79386d100c0adc1c" => :high_sierra
  end

  depends_on "cmake" => :build

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
