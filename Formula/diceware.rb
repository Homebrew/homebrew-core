class Diceware < Formula
  include Language::Python::Virtualenv

  desc "Passphrases to remember"
  homepage "https://github.com/ulif/diceware"
  url "https://github.com/ulif/diceware/archive/v0.9.6.tar.gz"
  sha256 "ff55832e725abff212dec1a2cb6e1c3545ae782b5f49ec91ec870a2b50e1f0e8"
  license "GPL-3.0"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "98142655d4892f15af5f4063171df2004ff3d394bfbd4d783af9fe03cbcb0add" => :catalina
    sha256 "4c2751c3a7d2f0049f0080eb6b8b0def6febe62252ef0957d06dbfced55271f0" => :mojave
    sha256 "5128fb4da8f9189651bf0b164c92ce58fc64290dc2539dc0b70a103799fb9405" => :high_sierra
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match(/(\w+)(-(\w+)){5}/, shell_output("#{bin}/diceware -d-"))
  end
end
