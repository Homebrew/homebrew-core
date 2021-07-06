class Proselint < Formula
  include Language::Python::Virtualenv

  desc "Linter for prose"
  homepage "http://proselint.com"
  url "https://files.pythonhosted.org/packages/ea/06/d5d7832b4eb44a79da7d90fb1d7b053b9e329a43f8ee4ea5700018799607/proselint-0.11.2.tar.gz"
  sha256 "5f90d5e3414928194be23efdf1e3e821bbb79279a598cf1710b29977029c4897"
  license "BSD-3-Clause"
  head "https://github.com/amperser/proselint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1eaeb5e24e02cb17c1f84512d6b7c593a17b6e8ad95d26988dc416c4c5828cc4"
    sha256 cellar: :any_skip_relocation, big_sur:       "e37af822aa0833431e772755d68911bac5c9ce1a2cad4d995d0238e8925039aa"
    sha256 cellar: :any_skip_relocation, catalina:      "50971786c55a1fd46196f16a2a838b2fc328863b32fcdd479a82d8d3640dc339"
    sha256 cellar: :any_skip_relocation, mojave:        "7c4d539da946b87e93d3b198d971ef4146bcaacfbad1b735923c300a8382a245"
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
