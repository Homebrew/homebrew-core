class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/e1/97/df3e00b4d795c96233e35d269c211131c5572503d2270afb6fed7d859cc2/codespell-2.2.6.tar.gz"
  sha256 "a8c65d8eb3faa03deabab6b3bbe798bea72e1799c7e9e955d57eca4096abcff9"
  license "GPL-2.0-only"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d883e3146afd3b3c3d43fb66fcb12b4a466be1ea59e958c8d4cab8081b031cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a93eb0e3cbf715721a6ecf29f042724c330b8de6e99262ee9a26d78dae4ff840"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "849e750f5af072fb384b837aa88de95726a3862eeb4d69e44459c986448ecde1"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3f40a6c36275b652dab12628b52b076b7ee913643b32585437595878eddb99d"
    sha256 cellar: :any_skip_relocation, ventura:        "5143b890b0acd3dda48e4290dcacd85026f2c19c014500f160238705ae1042b6"
    sha256 cellar: :any_skip_relocation, monterey:       "27d74d2c680f0bb58eccbb5687659116556574b3b6c1c71e9cc1ccd0437871be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c82558ab3dfb54399a1a33137fb37394b7f9c57970f92da0d279777d2213200"
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
