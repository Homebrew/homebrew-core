class Exodriver < Formula
  desc "Thin interface to LabJack devices"
  homepage "https://labjack.com/support/linux-and-mac-os-x-drivers"
  license "MIT"
  revision 1
  head "https://github.com/labjack/exodriver.git"

  stable do
    url "https://github.com/labjack/exodriver/archive/v2.5.3.tar.gz"
    sha256 "24cae64bbbb29dc0ef13f482f065a14d075d2e975b7765abed91f1f8504ac2a5"

    # Fix "__dyld section not supported".
    # Remove with the next release.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/f33e3149628486cd4db494e259001f4ee59f8694/exodriver/2.5.3-dyld.patch"
      sha256 "9098aabb25c65d4e9bafcab9640f3422e28a9000603c4d5c26525a51fe880bbb"
    end
  end

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
