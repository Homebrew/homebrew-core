class Proselint < Formula
  include Language::Python::Virtualenv

  desc "Linter for prose"
  homepage "http://proselint.com"
  url "https://files.pythonhosted.org/packages/42/ff/8e7ad0108b8faffdf2ec7d170b4a8a3c9bc91f5077debf5381ef14702588/proselint-0.10.2.tar.gz"
  sha256 "3a87eb393056d1bc77d898e4bcf8998f50e9ad84f7b9ff7cf2720509ac8ef904"
  license "BSD-3-Clause"
  revision 4
  head "https://github.com/amperser/proselint.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "15d139af2022e52914ad7ee102d3acbbbbf00b0406bd147bb5509765b5cbd3f5" => :big_sur
    sha256 "8d961c92da82a689bc3dd26ee643b1b46c02e05586d49866c1bd0502782d7a1d" => :arm64_big_sur
    sha256 "2f0a8c853ee9b4c7fb31f867d6371a36147772510a1af3431ccdcc272fbaac24" => :catalina
    sha256 "d410f307de6c9f59b5964b141e52d33318a0de5e871c5b8ed7663a5fbff2f279" => :mojave
    sha256 "787e948c2466df6ec0b3f8933702badc907bc08e34ca8b357c1568ad134dbd29" => :high_sierra
  end

  depends_on "python@3.9"

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
    assert_match "Comparison of an uncomparable", output
  end
end
