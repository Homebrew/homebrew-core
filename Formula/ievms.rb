class Ievms < Formula
  desc "Automated installation of Microsoft IE AppCompat virtual machines"
  homepage "https://xdissent.github.io/ievms/"
  url "https://github.com/xdissent/ievms/archive/v0.3.2.tar.gz"
  sha256 "bd48678bf5472de198c65b9cc14c74eb0348b448ed25e252d8cecbdf948571d7"

  bottle :unneeded

  depends_on "unar"

  def install
    bin.install "ievms.sh" => "ievms"
  end
end
