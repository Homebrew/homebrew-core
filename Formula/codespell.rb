class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/f2/2e/26fe0d3adc937f08e72930d9155bb5b7e07f5ca98b5f01e44a789407cd1e/codespell-2.2.0.tar.gz"
  sha256 "3dce0cd1348d277f8d934d1d4dcbbf510f9ddfd1b9005e9b25fb983189962561"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9d367b3e09c1e4df7739bc65740f06efb028f211decf69aa548bfdd4f39b337"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9d367b3e09c1e4df7739bc65740f06efb028f211decf69aa548bfdd4f39b337"
    sha256 cellar: :any_skip_relocation, monterey:       "3b046193f1b253adfc14e6d8e4a312a45b7625345723a0adb9e638fa8f602c6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b046193f1b253adfc14e6d8e4a312a45b7625345723a0adb9e638fa8f602c6b"
    sha256 cellar: :any_skip_relocation, catalina:       "3b046193f1b253adfc14e6d8e4a312a45b7625345723a0adb9e638fa8f602c6b"
    sha256 cellar: :any_skip_relocation, mojave:         "3b046193f1b253adfc14e6d8e4a312a45b7625345723a0adb9e638fa8f602c6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbd96b41878ac452cb7c3eaae676a52c5f6ac552918f57b1b6e5e675a00eb2d4"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", pipe_output("#{bin}/codespell -", "teh", 65)
  end
end
