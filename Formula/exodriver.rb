class Exodriver < Formula
  desc "Thin interface to LabJack devices"
  homepage "https://labjack.com/support/linux-and-mac-os-x-drivers"
  url "https://github.com/labjack/exodriver/archive/v2.6.0.tar.gz"
  sha256 "d2ccf992bf42b50e7c009ae3d9d3d3191a67bfc8a2027bd54ba4cbd4a80114b2"
  license "MIT"
  head "https://github.com/labjack/exodriver.git"

  bottle do
    cellar :any
    sha256 "aa86ed0ef4a6886bf65ba979938202a7bfabf2d844f2ffe14dee2466f3c65e59" => :catalina
    sha256 "9451412a4469cdf44e56eeac4c457a91b3363410859d4d48975ce3223f8b20d2" => :mojave
    sha256 "db8ef53e652b1296843207ee4d315b7ce5e7adf35ce5cf07f36d1d3f8dfdd28f" => :high_sierra
  end

  depends_on "libusb"

  def install
    system "make", "-C", "liblabjackusb", "install",
           "HEADER_DESTINATION=#{include}", "DESTINATION=#{lib}"
    ENV.prepend "CPPFLAGS", "-I#{include}"
    ENV.prepend "LDFLAGS", "-L#{lib}"
    system "make", "-C", "examples/Modbus"
    pkgshare.install "examples/Modbus/testModbusFunctions"
  end

  test do
    output = shell_output("#{pkgshare}/testModbusFunctions")
    assert_match /Result:\s+writeBuffer:/, output
  end
end
