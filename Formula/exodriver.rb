class Exodriver < Formula
  desc "Thin interface to LabJack devices"
  homepage "https://labjack.com/support/linux-and-mac-os-x-drivers"
  url "https://github.com/labjack/exodriver/archive/v2.6.0.tar.gz"
  sha256 "d2ccf992bf42b50e7c009ae3d9d3d3191a67bfc8a2027bd54ba4cbd4a80114b2"
  license "MIT"
  head "https://github.com/labjack/exodriver.git"

  bottle do
    cellar :any
    sha256 "ef5a220b029299aa31dd0311e0bf9f9f14ff7ca20bc95e6fa28b712bcc091b57" => :catalina
    sha256 "9a681697b7b08fca90cfb192ee7bb7ac4f41203b2a61213a967d2954d6a8f269" => :mojave
    sha256 "fc102b74dde20ca82f37a60ae708776bc05ce2a49b803f3b5ed2cce0a089eec4" => :high_sierra
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
