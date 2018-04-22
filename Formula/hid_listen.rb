class HidListen < Formula
  desc "Prints out debugging information from usb hid devices"
  homepage "https://www.pjrc.com/teensy/hid_listen.html"
  url "https://github.com/PaulStoffregen/hid_listen/archive/1.01.tar.gz"
  sha256 "4cb44c8fb0b5dab1c7acee5920c298bd4b193ada25fa186a5b9aff08ed48ba43"

  def install
    system "make", "OS=DARWIN", "hid_listen"
    bin.install "hid_listen"
  end

  test do
    system "true"
  end
end
