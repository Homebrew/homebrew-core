class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "http://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/libcec-4.0.0.tar.gz"
  sha256 "4c6ee8e44f2e6b28e3dfbee6c77df8d18605150ef69ab0564728b79a92a646ed"

  bottle do
    cellar :any
    sha256 "936b72a34281492b5730927a8ed8a3ec0b896e9b0ca320ec6a4f0d203051a2d1" => :sierra
    sha256 "417e766b366a2845b2178c83d1abb56263b1c4a28901ef5dd663ab4f97d644b1" => :el_capitan
    sha256 "b61d3a5aff0a3f7568665192829a77d4d437d382b9ae32b70a558ed6f360848d" => :yosemite
    sha256 "177e2e1b1bbc405d6408797750e5714471614464776457d8324cecbfb70375eb" => :mavericks
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
