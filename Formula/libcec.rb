class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "http://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/libcec-4.0.1.tar.gz"
  sha256 "92dd5d19675d571856c67785ea2dac0d11c4205a320c500981117152ffcdc15f"

  bottle do
    cellar :any
    sha256 "08c84729cd395ac1830bf463a2886608c2c192a5ca76f3bc322a6b2fd98049aa" => :sierra
    sha256 "8e8f44578d261c086202da14555464ee5e26f2a1aee147aa2e93002998e3a5dd" => :el_capitan
    sha256 "c27aedfea8faf634bef8692a9626d0e5d45dee1a0f7ef36c68132caae752bd41" => :yosemite
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
