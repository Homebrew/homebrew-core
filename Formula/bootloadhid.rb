class Bootloadhid < Formula
  desc "HID-based USB bootloader for AVR microcontrollers"
  homepage "https://www.obdev.at/products/vusb/bootloadhid.html"
  url "https://www.obdev.at/downloads/vusb/bootloadHID.2012-12-08.tar.gz"
  version "2012-12-08"
  sha256 "154e7e38629a3a2eec2df666edfa1ee2f2e9a57018f17d9f0f8f064cc20d8754"

  livecheck do
    url :homepage
    regex(/href=.*?bootloadHID[._-]v?(\d{4}-\d{1,2}-\d{1,2})\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2abf7dd9ed6601a8f2f42073b64abb33d20f7e81fdfd9d296f5441987d2054fe"
    sha256 cellar: :any,                 arm64_monterey: "9abfe94becc61f67c3a5b02d650fb723c38307b582efbdb606948076162a03c5"
    sha256 cellar: :any,                 arm64_big_sur:  "43f9864d0cf06fe06fbbb26c95b592cb2fc39c06090187deff8f81b8b35fc12f"
    sha256 cellar: :any,                 ventura:        "c7da175a271d8319af4c4fe923a2e1b1008be1bfc4ab99b1c0c59d3748f257c3"
    sha256 cellar: :any,                 monterey:       "aab53c65d93ea7a1274a39fc195e7e0599a20168a23764ec704b98d9b8ff082e"
    sha256 cellar: :any,                 big_sur:        "f77b7e77b043661da38b1c5d64140de538587d38a2ce50722a95c79339ceeee6"
    sha256 cellar: :any,                 catalina:       "aa0bc95a39610d6b5951d064d781d85b898ca2ebf230acbc60aa2f4e1f51e573"
    sha256 cellar: :any,                 mojave:         "36032498ab37f82f538d6aa037dac2b2f1c90f552ab5403f3e87c184bc47e75b"
    sha256 cellar: :any,                 high_sierra:    "59d545d65c052c2a62f171d4b6e92098a2725cb7c44997051e96863e30d26a03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eef4ea84385608a16af8533cd12d40b164a57e30bbfecfe9a58dd462e8cf22a6"
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
