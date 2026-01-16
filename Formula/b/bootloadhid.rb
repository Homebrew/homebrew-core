class Bootloadhid < Formula
  desc "HID-based USB bootloader for AVR microcontrollers"
  homepage "https://www.obdev.at/products/vusb/bootloadhid.html"
  url "https://www.obdev.at/downloads/vusb/bootloadHID.2012-12-08.tar.gz"
  sha256 "154e7e38629a3a2eec2df666edfa1ee2f2e9a57018f17d9f0f8f064cc20d8754"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url :homepage
    regex(/href=.*?bootloadHID[._-]v?(\d{4}-\d{1,2}-\d{1,2})\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "5b761a6cb6b73fde389f5aee23438b696185418e0f9c77775b7f93b83ed686a6"
    sha256 cellar: :any,                 arm64_sequoia:  "0c8755c106cb46118e33efda3ce06c507bc13949530ee87f10b4807c8cbcc55a"
    sha256 cellar: :any,                 arm64_sonoma:   "b7ff675ef48886f1dade51bab419acf430f6b0d19df5e3789231096bc15ebece"
    sha256 cellar: :any,                 arm64_ventura:  "2abf7dd9ed6601a8f2f42073b64abb33d20f7e81fdfd9d296f5441987d2054fe"
    sha256 cellar: :any,                 arm64_monterey: "9abfe94becc61f67c3a5b02d650fb723c38307b582efbdb606948076162a03c5"
    sha256 cellar: :any,                 arm64_big_sur:  "43f9864d0cf06fe06fbbb26c95b592cb2fc39c06090187deff8f81b8b35fc12f"
    sha256 cellar: :any,                 sonoma:         "71cb01dcdccd3e01d4e99e23a5c6e78b0becf9921fc67645c54a3a06c71e2a47"
    sha256 cellar: :any,                 ventura:        "c7da175a271d8319af4c4fe923a2e1b1008be1bfc4ab99b1c0c59d3748f257c3"
    sha256 cellar: :any,                 monterey:       "aab53c65d93ea7a1274a39fc195e7e0599a20168a23764ec704b98d9b8ff082e"
    sha256 cellar: :any,                 big_sur:        "f77b7e77b043661da38b1c5d64140de538587d38a2ce50722a95c79339ceeee6"
    sha256 cellar: :any,                 catalina:       "aa0bc95a39610d6b5951d064d781d85b898ca2ebf230acbc60aa2f4e1f51e573"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "51a4a8372175512d991362b12341aac01ac7d4b11b33af352de964815084e4cb"
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
    assert_equal "No data in input file, exiting.", shell_output("#{bin}/bootloadHID -r test.hex 2>&1").strip
  end
end
