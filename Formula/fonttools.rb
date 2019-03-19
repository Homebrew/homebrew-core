class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.39.0/fonttools-3.39.0.zip"
  sha256 "e21f35440877b24fdfe49e9c74d1084b50bd3be881a83e065d62424bd640fb41"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "704df3031c55b6bf9ea3e44e8c575d64bdbb43a9fbdc32d56fb2f8a58bf7de57" => :mojave
    sha256 "8e32a44a79329cffaf8c3c4e0431d050d012136d16ffa64b4033e4195d1b8861" => :high_sierra
    sha256 "4770d16c8052e3d36fc91dad7c93b658740ee6ccb6c78c7459c9d4f4f39ba560" => :sierra
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end
