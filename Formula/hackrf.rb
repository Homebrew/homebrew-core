class Hackrf < Formula
  desc "Low cost software radio platform"
  homepage "https://github.com/mossmann/hackrf"
  url "https://github.com/mossmann/hackrf/archive/v2018.01.1.tar.gz"
  sha256 "84dbb5536d3aa5bd6b25d50df78d591e6c3431d752de051a17f4cb87b7963ec3"
  head "https://github.com/mossmann/hackrf.git"

  bottle do
    cellar :any
    sha256 "ee0c6147fb2e29120ec71c64b41db770d77c5a8718f18a952bd45e3bae041c66" => :high_sierra
    sha256 "1b543cb3ea75d8a435b43df8e02e9468b1a6cf93fff2ab1a6605dcb0a514aacf" => :sierra
    sha256 "0c67009ad5e60aae45c203392dcee3a87e653177d996d296543b9de8d71ec827" => :el_capitan
    sha256 "d78f8872362611465da4cfddbadfece708195057b88894d713959afd06030dc6" => :yosemite
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
