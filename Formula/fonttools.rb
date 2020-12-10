class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/d0/82/7508f35aa3a13a07d9e28785797db3189a0dd9a2366a6314591074f811f3/fonttools-4.18.1.zip"
  sha256 "9054ec33beb043d7d5bd48a7964eb9f8a42464de9f9a335768de4ee183e64551"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cfadebeeb4a7e53f0fa57a4ad37defcf0045895ddadbdebe09edee29a1fa1e68" => :big_sur
    sha256 "e2c0cfb1924c02f6ca32533491a0b882b41a469c4c065baa4b51c57ff5700e63" => :catalina
    sha256 "3d3dfadb7f64c90f0d3763ba51ed2c694aa7240efe6462ff562efeeb473e2ce3" => :mojave
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
