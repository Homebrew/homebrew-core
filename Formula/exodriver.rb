class Exodriver < Formula
  desc "Thin interface to LabJack devices"
  homepage "https://labjack.com/support/linux-and-mac-os-x-drivers"
  url "https://github.com/labjack/exodriver/archive/v2.5.3.tar.gz"
  sha256 "24cae64bbbb29dc0ef13f482f065a14d075d2e975b7765abed91f1f8504ac2a5"

  head "https://github.com/labjack/exodriver.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "66fdf352cfefca64f29fdb41a368f6cf63a21df9ea5125529290dbd32af5f426" => :high_sierra
    sha256 "3f8be0b892a100dbaccb45052274321bf53a6d59c821be109f8b9a853a9d847a" => :sierra
    sha256 "fff6236e9b14044090926a48906d3f1a700df3d62587775f0c14064c8cc214ba" => :el_capitan
  end

  depends_on "libusb"

  def install
    cd "liblabjackusb"
    system "make", "-f", "Makefile",
                   "DESTINATION=#{lib}",
                   "HEADER_DESTINATION=#{include}",
                   "install"
  end
end
