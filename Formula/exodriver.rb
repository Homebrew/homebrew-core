class Exodriver < Formula
  desc "Thin interface to LabJack devices"
  homepage "https://labjack.com/support/linux-and-mac-os-x-drivers"
  url "https://github.com/labjack/exodriver/archive/v2.5.3.tar.gz"
  sha256 "24cae64bbbb29dc0ef13f482f065a14d075d2e975b7765abed91f1f8504ac2a5"

  head "https://github.com/labjack/exodriver.git"

  bottle do
    cellar :any
    sha256 "911a3d571d0ccc6f2ae8df67caec275470d179a2b435fec1cd521fe86f271bc6" => :sierra
    sha256 "5897f540e38aded535f6f3aa11d1df93c90305fe5196c106057ebbdda8620806" => :el_capitan
    sha256 "dc685c1d58f01fbe304d36fc33f1c2f2993599c83636054755c0f0b7cc887969" => :yosemite
    sha256 "bcc5eea01c69b14b1a2f3256105523016294ae54f9e026f03fbd4f65f7ce5c66" => :mavericks
  end

  option :universal

  depends_on "libusb"

  def install
    ENV.universal_binary if build.universal?

    cd "liblabjackusb"
    system "make", "-f", "Makefile",
                   "DESTINATION=#{lib}",
                   "HEADER_DESTINATION=#{include}",
                   "install"
  end
end
