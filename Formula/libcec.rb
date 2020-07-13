class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "http://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/libcec-6.0.1.tar.gz"
  sha256 "18fd4eb673800267a1e436128adb8792e8266457f3ea71604bd9ad07d945801b"

  bottle do
    cellar :any
    sha256 "d792e0747f1da7211c4b1f03eff3c94aa1b38576ccd209505e083d486128d12f" => :catalina
    sha256 "2693e3283048108f07731cbdf273443dc9d56bf8daa70813476a03101204faff" => :mojave
    sha256 "6af5045b2489ca9b4f133c96f4da224666e82b64781d3b7bd2ada087e33a1b4f" => :high_sierra
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
