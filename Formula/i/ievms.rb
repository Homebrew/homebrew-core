class Ievms < Formula
  desc "Automated installation of Microsoft IE AppCompat virtual machines"
  homepage "https://xdissent.github.io/ievms/"
  url "https://github.com/xdissent/ievms/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "95cafdc295998712c3e963dc4a397d6e6a823f6e93f2c119e9be928b036163be"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "64f7839125fd69525935b7cd3eee26cb7ef05010105218c3135d7ac81f7cd0db"
  end

  disable! date: "2024-08-12", because: :no_license

  depends_on "unar"

  def install
    bin.install "ievms.sh" => "ievms"
  end
end
