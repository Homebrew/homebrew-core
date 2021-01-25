class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/f3/d1/0553aad57ca850516c2a666690fd818fa9e80f1293e460be976eee4dcc86/codespell-2.0.0.tar.gz"
  sha256 "dd9983e096b9f7ba89dd2d2466d1fc37231d060f19066331b9571341363c77b8"
  license "GPL-2.0-only"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c593fceba8be94074570221a350741dc1f11929f5c1176197e3962f34fb46363" => :big_sur
    sha256 "75ab1ae15931e2358946065d9d9b53ec0a11516de94e69def4b097933207372e" => :arm64_big_sur
    sha256 "2d338cbcf31abc4712005bca0cd59543403a1525a24952b14fadc6592c2c7791" => :catalina
    sha256 "c53e89d6f26521dac01d2f26952674a12228e8f70070c9a02abd0c31744d2128" => :mojave
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", shell_output("echo teh | #{bin}/codespell -", 65)
  end
end
