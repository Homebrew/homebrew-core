class Hr < Formula
  desc "<hr />, for your terminal window"
  homepage "https://github.com/LuRsT/hr"
  url "https://github.com/LuRsT/hr/archive/1.3.tar.gz"
  sha256 "258ff3121369d17c5c70fa18e466ac01cdb4cf890c605f7a5e706d5b1a3afebf"
  license "MIT"
  head "https://github.com/LuRsT/hr.git"

  bottle :unneeded

  def install
    bin.install "hr"
    man1.install "hr.1"
  end

  test do
    system "#{bin}/hr", "-#-"
  end
end
