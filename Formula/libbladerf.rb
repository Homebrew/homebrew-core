class Libbladerf < Formula
  desc "bladeRF USB 3.0 Superspeed Software Defined Radio Source"
  homepage "https://nuand.com/"
  url "https://github.com/Nuand/bladeRF/archive/2016.06.tar.gz"
  sha256 "6e6333fd0f17e85f968a6180942f889705c4f2ac16507b2f86c80630c55032e8"
  head "https://github.com/Nuand/bladeRF.git"

  bottle do
    sha256 "a6aa49db1410c4d2c43edd8564efa6a962093ac88132183d28aa5d09591fe3c3" => :el_capitan
    sha256 "fa8f653507ad414695029cdf1620de47e8bf0fb7901531f1ea241f39768db377" => :yosemite
    sha256 "0db3f3411af41d50509487ab199092d2264aca0ab6212616d0ff8ec008cdc612" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "libusb"

  patch do
    url "https://github.com/Nuand/bladeRF/commit/b6f6267.diff"
    sha256 "c9b80e04e7e6c7b6ddc6ce3944650d6ae9ad30f4187857a84632993fb9ccc39d"
  end

  def install
    mkdir "host/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"bladeRF-cli", "--version"
  end
end
