class Diceware < Formula
  include Language::Python::Virtualenv

  desc "Passphrases to remember"
  homepage "https://github.com/ulif/diceware"
  url "https://github.com/ulif/diceware/archive/v0.9.6.tar.gz"
  sha256 "ff55832e725abff212dec1a2cb6e1c3545ae782b5f49ec91ec870a2b50e1f0e8"
  license "GPL-3.0"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "510a0f4aca2e72306d28a54c0c5d5a2d5dd98b6a7c5e8b5a104e637b1499866a" => :catalina
    sha256 "f5dfaf498b1d3097b8b5346b215e81f1af6dcd98da65ec123a8b129690df3650" => :mojave
    sha256 "a5838d0d6d69978d1bd9d56699ae4256af9a56bd5636614e783b4e4379c8365f" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match(/(\w+)(-(\w+)){5}/, shell_output("#{bin}/diceware -d-"))
  end
end
