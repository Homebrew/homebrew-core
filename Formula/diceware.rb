class Diceware < Formula
  include Language::Python::Virtualenv

  desc "Passphrases to remember"
  homepage "https://github.com/ulif/diceware"
  url "https://github.com/ulif/diceware/archive/v0.9.6.tar.gz"
  sha256 "ff55832e725abff212dec1a2cb6e1c3545ae782b5f49ec91ec870a2b50e1f0e8"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "f86f57c5ebcdbab709ee24572459743f92cd60a1877225af5124ca56ac592d1e" => :catalina
    sha256 "83c6ce549c1b824d0bc3c9c550ba8f0837cf0021ce0dc62b22ed43df33a31fbc" => :mojave
    sha256 "fe863d5aa48b47eb18aa8b294cf0a9e63fea4d9c58c0d14d1938fb649a1e074f" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match(/(\w+)(\-(\w+)){5}/, shell_output("#{bin}/diceware -d-"))
  end
end
