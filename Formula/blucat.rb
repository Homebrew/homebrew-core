class Blucat < Formula
  desc "netcat for Bluetooth"
  homepage "http://blucat.sourceforge.net/blucat/"
  url "https://github.com/ieee8023/blucat/archive/v0.91.tar.gz"
  sha256 "3e006d25b7e82689826c89ffbbfa818f8b78cced47e6d0647e901578d330a2f4"
  head "https://github.com/ieee8023/blucat.git"

  bottle do
    cellar :any
    sha256 "83405eb090f0790e63a1edba4e369d6c87ada03219b1412e1d417a7b8fc66ba3" => :el_capitan
    sha256 "5453287bd14c8cc5dc5f575ea01a618ddb213035cbe25536ac1b52d212d34d1b" => :yosemite
    sha256 "17c6e60c3900d8c7065108d87d43dfdee76906c18bc8c872577f4d75cb984596" => :mavericks
  end

  depends_on "ant" => :build
  depends_on :java => "1.6+"

  def install
    system "ant"
    libexec.install "blucat"
    libexec.install "lib"
    libexec.install "build"
    bin.write_exec_script libexec/"blucat"
  end

  test do
    begin
      io = IO.popen("#{bin}/blucat scan 0")
      sleep 1
      assert_equal "#Scanning RFCOMM Channels 1-30", io.gets.strip
    ensure
      Process.kill "TERM", io.pid
      Process.wait io.pid
    end
  end
end
