class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/c9/5a/c325a3c8a0f4a99e10ba0b86e4ad89413da50b8b7394a5cbbdef263f3a80/fonttools-4.19.0.zip"
  sha256 "53d9944beb1a6cb3c46dd30eca9a110c610133f22d2f22e9c0f06dd20b73d6f3"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c5593bda52783eda1a0f277968f076946024afe0a57d8e327081d8a5434dad0" => :big_sur
    sha256 "0480e880a0abb0f33eda6eaf5f4e91f0eef7f7600ccd3494ab9f23c49ee4cd62" => :arm64_big_sur
    sha256 "8d3f2e45a5e29794e39cec9fc49c63dab3df9f0480a5f77c94387076300bd9fb" => :catalina
    sha256 "2692b0944ccbe8cba41575d606eddbd6f0ad55d6b342ac406882b327aa74b01c" => :mojave
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
