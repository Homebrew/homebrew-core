class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "http://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/libcec-4.0.0-3.tar.gz"
  sha256 "5c82a3f7075df35319bc223627f2decedb38a3322c621bb925f7807aa1e43d50"

  bottle do
    cellar :any
    sha256 "fca87d5d42d6a5119723c2644aaaf57c852ef752f3da110375e6d78c60d22df8" => :sierra
    sha256 "ce89ff77d0e8a0c43d58010ef8ce75f3ec512b178b60ad66099a47a070323b39" => :el_capitan
    sha256 "6b6cdda80e312020a280bbc12c27fb2cc6cb6a26aa8be14a0c3a4ec0f661ba53" => :yosemite
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
