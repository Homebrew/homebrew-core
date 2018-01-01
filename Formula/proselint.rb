class Proselint < Formula
  include Language::Python::Virtualenv

  desc "Linter for prose"
  homepage "http://proselint.com"
  url "https://files.pythonhosted.org/packages/1b/d2/2e6afa3f933a12bfb1eb588f1ec8c26f915935356d8a0e51b2e5c53bfd04/proselint-0.8.0.tar.gz"
  sha256 "08d48494533f178eb7a978cbdf10ddf85ed7fc2eb486ff5e7d0aecfa08e81bbd"
  head "https://github.com/amperser/proselint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "348b9735cf0f74e60458401ea04443e1bdee7b16425bbab7dc4dcc22a3b4afe2" => :high_sierra
    sha256 "2b21bf831fb77fb70d54f7df0ec4d17828b6b3dd34fd8067f5e4c0907936f510" => :sierra
    sha256 "1a519abf70fb0ff474a9cb7f1f26cc47ab14db96e0bff2234dde0cf8a21a4162" => :el_capitan
    sha256 "3251f7ab8536ce8ce27973ae7b3578a404b712688dfa79c4f7d2413d1760ae32" => :yosemite
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/00/2b/8d082ddfed935f3608cc61140df6dcbf0edea1bc3ab52fb6c29ae3e81e85/future-0.16.0.tar.gz"
    sha256 "e39ced1ab767b5936646cedba8bcce582398233d6a627067d4c6a454c90cfedb"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/proselint --compact -", "John is very unique.")
    assert_match /weasel_words\.very.*uncomparables/m, output
  end
end
