class Jello < Formula
  include Language::Python::Virtualenv

  desc "Filter JSON and JSON Lines data with Python syntax"
  homepage "https://github.com/kellyjonbrazil/jello"
  url "https://files.pythonhosted.org/packages/9e/8c/c625f0d6c824cf955a29d6d3df537fe310c4b65ead63afbb77ec10a1c729/jello-1.4.4.tar.gz"
  sha256 "c42d5202282fa10b57f5830b8e4a74da7a75d585f000b812bbfd90bff28c2bfc"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cf89b26555543aa7ee63d93e02df14d260fc06ba1dffb9ece2c070fadaaa6f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2cf89b26555543aa7ee63d93e02df14d260fc06ba1dffb9ece2c070fadaaa6f4"
    sha256 cellar: :any_skip_relocation, monterey:       "e1c991340147788989124b846af28bfa283dccf1af47fcdf9c03f2fd2bd0299c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1c991340147788989124b846af28bfa283dccf1af47fcdf9c03f2fd2bd0299c"
    sha256 cellar: :any_skip_relocation, catalina:       "e1c991340147788989124b846af28bfa283dccf1af47fcdf9c03f2fd2bd0299c"
    sha256 cellar: :any_skip_relocation, mojave:         "e1c991340147788989124b846af28bfa283dccf1af47fcdf9c03f2fd2bd0299c"
  end

  depends_on "python@3.10"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
  end

  def install
    virtualenv_install_with_resources
    man1.install "jello/man/jello.1"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/jello _.foo", "{\"foo\":1}")
  end
end
