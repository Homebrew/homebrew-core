class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/26/37/c524f1750635cb8806240013af1fd4147a60019f9a80e788759e3d2fb644/codespell-2.1.0.tar.gz"
  sha256 "19d3fe5644fef3425777e66f225a8c82d39059dcfe9edb3349a8a2cf48383ee5"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "75ab1ae15931e2358946065d9d9b53ec0a11516de94e69def4b097933207372e"
    sha256 cellar: :any_skip_relocation, big_sur:       "c593fceba8be94074570221a350741dc1f11929f5c1176197e3962f34fb46363"
    sha256 cellar: :any_skip_relocation, catalina:      "2d338cbcf31abc4712005bca0cd59543403a1525a24952b14fadc6592c2c7791"
    sha256 cellar: :any_skip_relocation, mojave:        "c53e89d6f26521dac01d2f26952674a12228e8f70070c9a02abd0c31744d2128"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", shell_output("echo teh | #{bin}/codespell -", 65)
  end
end
