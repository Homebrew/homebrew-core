class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "http://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/libcec-4.0.4.tar.gz"
  sha256 "4382a964bf8c511c22c03cdab5ba2d81c241536e6479072a61516966804f400a"

  bottle do
    cellar :any
    sha256 "a763a8c370aa73928eb9dd06fd5f4ce6693cfa6449916ef27ab4f349d48b8cb7" => :catalina
    sha256 "54f45924069082bbd051daa04161954afb6fb1f0a5f664601ce2e4a70bb12c39" => :mojave
    sha256 "ea99237d0eb6e166b9fdde19b756066a826f49f68f1f6994d5f1a09843b2db61" => :high_sierra
    sha256 "a450148702479250d2677a418fc33e8ff2d70820b989d30b716b2c39a8090273" => :sierra
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
