class Proselint < Formula
  include Language::Python::Virtualenv

  desc "Linter for prose"
  homepage "http://proselint.com"
  url "https://files.pythonhosted.org/packages/e9/fc/acd766ee050c8a8a27439fcb37a7042d9fc44bf840b48ebb32a5546a9db8/proselint-0.12.0.tar.gz"
  sha256 "2a98d9c14382d94ed9122a6c0b0657a814cd5c892c77d9477309fc99f86592e6"
  license "BSD-3-Clause"
  head "https://github.com/amperser/proselint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d0b1ed00f35f99465b9781023fd59af96e986bc46b5cba41247cc70cbbe64f0d"
    sha256 cellar: :any_skip_relocation, big_sur:       "3a3865b2a11e676c91cab82ca02d9a5b1f7f7f2aeec309cfd85e065387ce2999"
    sha256 cellar: :any_skip_relocation, catalina:      "adb95b9a130c0e44115b9e05b012be58870b56416189cfcf2bc02ebfb04f695a"
    sha256 cellar: :any_skip_relocation, mojave:        "b2bc217150a230017811eb50ae36d85c812b44850afb6e60e5895d57c0ac9cca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee110a0d127db7fe91ce694498faaf1a8834d1f32688c9a33274f40434e35c0c"
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
