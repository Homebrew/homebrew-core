class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/81/30/e1b32067c551d745df2bdc9f1d510422d8a5819ca3b610b4433654cf578c/codespell-2.2.5.tar.gz"
  sha256 "6d9faddf6eedb692bf80c9a94ec13ab4f5fb585aabae5f3750727148d7b5be56"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8aa82a4c3f4aa50d6f72d96fefd13f3f0c9b6a364ca0399252a3401703df8a84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c847fb8c0268d2d747f056ed1211accd80c2c1519dbd1b4a903d9711c51da821"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78df4c24f208a27d026a49e4d4969945b262b94a680dc780560beebf05eaa22e"
    sha256 cellar: :any_skip_relocation, ventura:        "98c24425f23f166a1eb0639bf979cd53f61c7f11aa8e447d325458165b60df15"
    sha256 cellar: :any_skip_relocation, monterey:       "7889a56823419a602800b6e80c839fb872bf5816a6bd4f27ecf3ddcb28a3448d"
    sha256 cellar: :any_skip_relocation, big_sur:        "28076847bb2b331667668383a35957f34b8268549d3ba18d1321087b7d7458a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f36d32df3d6b68858377cbe3c597099c646acba5f0e7ffbcf540952988e9ce7a"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", pipe_output("#{bin}/codespell -", "teh", 65)
  end
end
