class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "http://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/libcec-6.0.0.tar.gz"
  sha256 "7c6add855246952dd8d9be3ad24d2bd193394ed9f42c69cbb6905cea6eef42f4"

  bottle do
    cellar :any
    sha256 "fcca0daf72607150ca1468ec90312807c74ebf75971f394e5db86a08f1f36d61" => :catalina
    sha256 "92da05c25aaaa1af81909bbfda5455622dae620d2dcff095600597a06547c8f5" => :mojave
    sha256 "5b4d87d43f65d172f737fd8d88e2a0b6f5e1220109dc5745ca5daacb5aeee0ba" => :high_sierra
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
