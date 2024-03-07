class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/e1/97/df3e00b4d795c96233e35d269c211131c5572503d2270afb6fed7d859cc2/codespell-2.2.6.tar.gz"
  sha256 "a8c65d8eb3faa03deabab6b3bbe798bea72e1799c7e9e955d57eca4096abcff9"
  license "GPL-2.0-only"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c44907e2ba97c188b4fd4cbeb1fe83dffafc126ba79b779451beb4f07952b463"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33ce0ce026f1073bf52f02933a7f07e7b8dee0d62f692508b5df4658321c06db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1f925c4fb044296fa3698ec96fd92a26584cc41aa8dd66e79d8eabcf887f9cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "8de008b8ad1e7bbe2b284a4fb737f8a44c1c52020e70fcf101a8d5532895513b"
    sha256 cellar: :any_skip_relocation, ventura:        "d279e0643f56fff875cda9a08acb05e84fd6063c7481dff753a379dcb2005525"
    sha256 cellar: :any_skip_relocation, monterey:       "fefc37ef1acf73074ce556c6cf94f70951d8ebd14ad1af109eb69baa2006b1a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d6369de2dc22d6dec2798c459a5299a8c4de42f4912b31fe5928377d03acc76"
  end

  depends_on "python@3.12"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c8/1f/e026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44/setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", pipe_output("#{bin}/codespell -", "teh", 65)
  end
end
