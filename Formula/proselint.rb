class Proselint < Formula
  include Language::Python::Virtualenv

  desc "Linter for prose"
  homepage "http://proselint.com"
  url "https://files.pythonhosted.org/packages/04/ee/60506bd37251f7396d73942e2bd3dac9b788269d46cf1372c5e0602e5682/proselint-0.11.3.tar.gz"
  sha256 "e92e68b8bbb24dbf535eac59ac69b8b4ae9a0610f4f0dc83c18732150c465abf"
  license "BSD-3-Clause"
  head "https://github.com/amperser/proselint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3b1c20bd0b59fd486ad26ae6e1e0d2b880c5f179be56afad5933b691de2a134f"
    sha256 cellar: :any_skip_relocation, big_sur:       "431e17c8890af9a48429e217c2a40e14fbc056c852525d9292622cfa848e69cf"
    sha256 cellar: :any_skip_relocation, catalina:      "03fc6a15ddd559ff73537a6dee97be1bbba8f22b8f9fd602f97c0d4c533d83a4"
    sha256 cellar: :any_skip_relocation, mojave:        "421135829a1cd5991fde1ab1cf82739fbe0f9d4a6d375c51b41dabfdc85dffd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb01ede21476c8cba1343ba737c711c20beef4a0666c1b3b5632210d14b43765"
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
