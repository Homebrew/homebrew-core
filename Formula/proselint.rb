class Proselint < Formula
  include Language::Python::Virtualenv

  desc "Linter for prose"
  homepage "http://proselint.com"
  url "https://files.pythonhosted.org/packages/7e/06/f0f8e077396e7e0ef9b8e13ec5bab766c3aaf1b9d26f718f9e566981f8c2/proselint-0.11.1.tar.gz"
  sha256 "76133b5d97ef6c3020840c3c601054fd163539283ca78387145f649be6214d38"
  license "BSD-3-Clause"
  head "https://github.com/amperser/proselint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8d961c92da82a689bc3dd26ee643b1b46c02e05586d49866c1bd0502782d7a1d"
    sha256 cellar: :any_skip_relocation, big_sur:       "15d139af2022e52914ad7ee102d3acbbbbf00b0406bd147bb5509765b5cbd3f5"
    sha256 cellar: :any_skip_relocation, catalina:      "2f0a8c853ee9b4c7fb31f867d6371a36147772510a1af3431ccdcc272fbaac24"
    sha256 cellar: :any_skip_relocation, mojave:        "d410f307de6c9f59b5964b141e52d33318a0de5e871c5b8ed7663a5fbff2f279"
    sha256 cellar: :any_skip_relocation, high_sierra:   "787e948c2466df6ec0b3f8933702badc907bc08e34ca8b357c1568ad134dbd29"
  end

  depends_on "python@3.9"

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/proselint --compact -", "John is very unique.")
    assert_match "Comparison of an uncomparable", output
  end
end
