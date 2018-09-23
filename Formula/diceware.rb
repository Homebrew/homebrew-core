class Diceware < Formula
  include Language::Python::Virtualenv

  desc "Passphrases to remember"
  homepage "https://github.com/ulif/diceware"
  url "https://github.com/ulif/diceware/archive/v0.9.5.tar.gz"
  sha256 "70c5884eed7f9d55204075cc8816ef7259000a0548f930a98d51132eef5c90ad"

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match(/(\w+)(\-(\w+)){5}/, shell_output("#{bin}/diceware -d-"))
  end
end
