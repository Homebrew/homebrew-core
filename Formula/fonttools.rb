class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/3d/f9/ebd619f1393d4536bbf4becb9ffc41d95d01b38441244b28fa39b827db4a/fonttools-4.18.2.zip"
  sha256 "5c50af6fb9b4de4609c0e5558f3444c20f8632aa319319a7ef14fd5ba677c9f8"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2fc8e51466b4fc346c8ce3780692c1176a266b9d6aadbc16a748725684e89495" => :big_sur
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
