class Proselint < Formula
  include Language::Python::Virtualenv

  desc "Linter for prose"
  homepage "http://proselint.com"
  url "https://files.pythonhosted.org/packages/f3/e8/97487c264e3aa08171bc9a028f65e023ecd1e77680b23df67b871c840fda/proselint-0.10.1.tar.gz"
  sha256 "64ddfb036b63fa062c1303a784924c842e490ff6b7d90ee84bf9622422f888d8"
  head "https://github.com/amperser/proselint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "82c94cbcee61bff8f8caad4811aa43e3f94468711112453d015c4d22e863ba8e" => :high_sierra
    sha256 "dced8e141627ce6d735e24663839f1037f2b52e4a78945f5c6b9b5b735405146" => :sierra
    sha256 "9ae605c01455d630279ec13589d6c2577745a04ff02b6e1d63537e9a39976e14" => :el_capitan
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
