class Diceware < Formula
  include Language::Python::Virtualenv

  desc "Passphrases to remember"
  homepage "https://github.com/ulif/diceware"
  url "https://files.pythonhosted.org/packages/8b/ba/db6c087f044f6a753a85c0d8b25848122018ced2130061298c0c08940a54/diceware-1.0.1.tar.gz"
  sha256 "54b690809f0c56ab3085a18e15a0c3804d4a0d127f38aef0b5cf5f859d0f6639"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "3fecb6390567f06e893d664105063c32aa80a8bb3b2f4cdc1944b8850b5c9749"
  end

  depends_on "python@3.14"

  def install
    venv = virtualenv_install_with_resources
    man1.install "diceware.1"

    # Build an :all bottle
    file = venv.site_packages.glob("diceware/wordlist.py")
    inreplace file, "/usr/local/share/#{name}", HOMEBREW_PREFIX/"share/#{name}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/diceware --version")
    assert_match(/(\w+)(-(\w+)){5}/, shell_output("#{bin}/diceware -d-"))
  end
end
