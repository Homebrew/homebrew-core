class Proselint < Formula
  include Language::Python::Virtualenv

  desc "Linter for prose"
  homepage "http://proselint.com"
  url "https://files.pythonhosted.org/packages/e9/fc/acd766ee050c8a8a27439fcb37a7042d9fc44bf840b48ebb32a5546a9db8/proselint-0.12.0.tar.gz"
  sha256 "2a98d9c14382d94ed9122a6c0b0657a814cd5c892c77d9477309fc99f86592e6"
  license "BSD-3-Clause"
  head "https://github.com/amperser/proselint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4d55d3cf59433f61715e38ba71aef2f942311040b78aba87cdaf5c74c25f4618"
    sha256 cellar: :any_skip_relocation, big_sur:       "1e7dc0f85d276cac8a93f4782ad7e9fb04bd32f3ecc4b35d14798acfed6c984d"
    sha256 cellar: :any_skip_relocation, catalina:      "7eedf6711251d705cfc9ba839393d08dcd4db47cb0ec0d8adb7a1577d8dc7f0f"
    sha256 cellar: :any_skip_relocation, mojave:        "ba192136fc7438bdc77cf62adaeafb2f9cd44bc626161b2ccdbafeeaac9e11fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d76b590cbea849e4883e8f6684dc2393254850e248acb0a9bd092edb2edb2b99"
  end

  depends_on "python@3.9"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/proselint --compact -", "John is very unique.")
    assert_match "Comparison of an uncomparable", output
  end
end
