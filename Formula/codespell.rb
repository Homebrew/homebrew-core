class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/7e/37/b15b4133e90bbef5acecfd2f3f3871c1352ee281c042fd64a22a72735fb8/codespell-1.17.1.tar.gz"
  sha256 "25a2ecd86b9cdc111dc40a30d0ed28c578e13a0ce158d1c383f9d47811bfcd23"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb3fb87c3d707656b5c796fd40a13b6e7d0170f5cc4db6361751074b1f089bcf" => :catalina
    sha256 "f44c96916092e661dfa53499d3570b98bba5fbcf964751f55c775e0aee68b37c" => :mojave
    sha256 "752254907866753d1941f39193d67cb2fbaa54f294d6d0f4a1f11cd8a8247aae" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", shell_output("echo teh | #{bin}/codespell -", 1)
  end
end
