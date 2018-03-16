class Hackrf < Formula
  desc "Low cost software radio platform"
  homepage "https://github.com/mossmann/hackrf"
  url "https://github.com/mossmann/hackrf/archive/v2018.01.1.tar.gz"
  sha256 "84dbb5536d3aa5bd6b25d50df78d591e6c3431d752de051a17f4cb87b7963ec3"
  head "https://github.com/mossmann/hackrf.git"

  bottle do
    cellar :any
    sha256 "430173362cc05912520a38f41ce465a0966f1c8d849fd492f0b40074425c3f88" => :high_sierra
    sha256 "f33bc6bde41e6522d587bc574c01e1402ccbde6759dec5e9d1a1e5f593e189b3" => :sierra
    sha256 "909a5a9aca6f81cbab08bb7c063f3ee0e666bb5b44af86ebbec62cbdaf3e3b33" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "fftw"

  def install
    cd "host" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    shell_output("#{bin}/hackrf_transfer", 1)
  end
end
