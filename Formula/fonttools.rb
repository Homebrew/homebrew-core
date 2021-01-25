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
    sha256 "2fc8e51466b4fc346c8ce3780692c1176a266b9d6aadbc16a748725684e89495" => :big_sur
    sha256 "365031c45833a0342bf1b558233be15e8014816184eeeb85ada1dcd7076ea57d" => :arm64_big_sur
    sha256 "98704bad103b75973589ab1eb1e488509394430e0dd7f226ff67dfadd246800e" => :catalina
    sha256 "a4a4710e08590d88df88822ec506a34adbc6cd95d17e10f542300f52c155f62b" => :mojave
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
