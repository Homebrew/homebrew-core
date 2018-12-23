class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "http://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/libcec-4.0.4.tar.gz"
  sha256 "4382a964bf8c511c22c03cdab5ba2d81c241536e6479072a61516966804f400a"

  bottle do
    cellar :any
    sha256 "4261d39629e37d920a90ca22f410a9d47a44dd328c2fc9c098686d862074b727" => :mojave
    sha256 "5d77635bb42a9f2d589277becfe0bee6ffa8e4ded57435e2fcc6bd0e16cd2d62" => :high_sierra
    sha256 "9eae1d4e8cba0df63ea8208f5746a04b135687924d945af3a4e7f7b099b66949" => :sierra
  end

  depends_on "cmake" => :build

  resource "p8-platform" do
    url "https://github.com/Pulse-Eight/platform/archive/p8-platform-2.1.0.1.tar.gz"
    sha256 "064f8d2c358895c7e0bea9ae956f8d46f3f057772cb97f2743a11d478a0f68a0"
  end

  needs :cxx11

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
