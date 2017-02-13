class Hackrf < Formula
  desc "Low cost software radio platform"
  homepage "https://github.com/mossmann/hackrf"
  url "https://github.com/mossmann/hackrf/archive/v2017.02.1.tar.gz"
  sha256 "7f84e61d07ab0ae4bd05912a4167cd7bc3cc2618d880bbd3a4579f65a2f1bbbf"
  head "https://github.com/mossmann/hackrf.git"

  bottle do
    cellar :any
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
