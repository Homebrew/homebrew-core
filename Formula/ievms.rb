class Ievms < Formula
  desc "Automated installation of Microsoft IE AppCompat virtual machines"
  homepage "https://xdissent.github.io/ievms/"
  url "https://github.com/xdissent/ievms/archive/v0.3.3.tar.gz"
  sha256 "95cafdc295998712c3e963dc4a397d6e6a823f6e93f2c119e9be928b036163be"

  bottle :unneeded

  depends_on "unar"

  def install
    bin.install "ievms.sh" => "ievms"
  end
end
