class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/2d/9d/1d0903dff693160f893ca6abcabad545088e7a2ee0a6deae7c24e958be69/codespell-2.4.2.tar.gz"
  sha256 "3c33be9ae34543807f088aeb4832dfad8cb2dae38da61cac0a7045dd376cfdf3"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "470bccfd8662e9c8dac8519e78693b2a992b01de4ef723036cef26122c0ecd4a"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codespell --version")
    assert_equal "1: teh\n\tteh ==> the\n", pipe_output("#{bin}/codespell -", "teh", 65)
  end
end
