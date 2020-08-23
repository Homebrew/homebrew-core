class Bootloadhid < Formula
  desc "HID-based USB bootloader for AVR microcontrollers"
  homepage "https://www.obdev.at/products/vusb/bootloadhid.html"
  url "https://www.obdev.at/downloads/vusb/bootloadHID.2012-12-08.tar.gz"
  version "2012-12-08"
  sha256 "154e7e38629a3a2eec2df666edfa1ee2f2e9a57018f17d9f0f8f064cc20d8754"

  bottle do
    cellar :any
    sha256 "aa0bc95a39610d6b5951d064d781d85b898ca2ebf230acbc60aa2f4e1f51e573" => :catalina
    sha256 "36032498ab37f82f538d6aa037dac2b2f1c90f552ab5403f3e87c184bc47e75b" => :mojave
    sha256 "59d545d65c052c2a62f171d4b6e92098a2725cb7c44997051e96863e30d26a03" => :high_sierra
  end

  depends_on "libusb-compat"

  def install
    Dir.chdir "commandline"
    system "make"
    bin.install "bootloadHID"
  end

  test do
    touch "test.hex"
    assert_equal "No data in input file, exiting.", pipe_output("#{bin}/bootloadHID -r test.hex 2>&1").strip
  end
end
