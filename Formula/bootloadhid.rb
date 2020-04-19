class Bootloadhid < Formula
  desc "HID-based USB bootloader for AVR microcontrollers"
  homepage "https://www.obdev.at/products/vusb/bootloadhid.html"
  url "https://www.obdev.at/downloads/vusb/bootloadHID.2012-12-08.tar.gz"
  version "2012-12-08"
  sha256 "154e7e38629a3a2eec2df666edfa1ee2f2e9a57018f17d9f0f8f064cc20d8754"

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
