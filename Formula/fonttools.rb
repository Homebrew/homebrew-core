class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/97/10/fff006d7a88faa7b959fdf97cebe348afb6d61f626790298821d136d1f79/fonttools-4.19.1.zip"
  sha256 "4a2b8450bd3b1c23e6259d37c0f1e403519c91b8373b83bb9e3c6e70748cf07b"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6c1936ca273b9c542d5970b86829e518b4978eea5c687d97016ad71e7093ac93"
    sha256 cellar: :any_skip_relocation, big_sur:       "e7e39a2299ba1e7e75edbf7f9eeb485d1db16030dd79b2f220fa24ce0ad1d54a"
    sha256 cellar: :any_skip_relocation, catalina:      "ee899da6621e1cbff32f22c30c41685912be30e6c7899436b32bc9275ba626f0"
    sha256 cellar: :any_skip_relocation, mojave:        "646ec88f27fdb6d451781c234f45d8e778ba84a01f800b28e9ffcee9fa02011e"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
    system bin/"ttx", "ZapfDingbats.ttf"
  end
end
