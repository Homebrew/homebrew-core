class Proselint < Formula
  include Language::Python::Virtualenv

  desc "Linter for prose"
  homepage "http://proselint.com"
  url "https://files.pythonhosted.org/packages/ed/84/d2adefc48e8cf4d8c385cd39d68c9ff67a714a0a95b5ee25e6c7c4448bf0/proselint-0.10.0.tar.gz"
  sha256 "0ffaf8238a71b51a54c43bd60b69df2370ab9ccfc018e23120323ee16a49b94e"
  head "https://github.com/amperser/proselint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b95d31abac563ac4b5d5b97e2a02b4696852cad6f37af582e9167281b7ee7c5c" => :high_sierra
    sha256 "f6a9d520464984651f89b2fd5773024ceff8ada11d6ce91154ac80c5ba16c87d" => :sierra
    sha256 "96fa375a8844143a454bb673eaeb7e7f48dd25abdfb130a1e9cdcb6f78402f73" => :el_capitan
  end

  depends_on "python@2"

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/00/2b/8d082ddfed935f3608cc61140df6dcbf0edea1bc3ab52fb6c29ae3e81e85/future-0.16.0.tar.gz"
    sha256 "e39ced1ab767b5936646cedba8bcce582398233d6a627067d4c6a454c90cfedb"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/proselint --compact -", "John is very unique.")
    assert_match /weasel_words\.very.*uncomparables/m, output
  end
end
