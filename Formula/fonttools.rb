class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/archive/3.32.0.tar.gz"
  sha256 "1e328ed8dec1de53140fef2c8052f4c97119914f95f39927378c1c4b75afae44"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d16825acf6393878863f8f59c8fb72d86c3ccc26dafbe206adcf8b12284aef4c" => :mojave
    sha256 "a9d9e3b76165418f9abc14dea1fdf880d65e1ea51125a212fe9fdf22ef49fe0a" => :high_sierra
    sha256 "ef85dbb42072a800f88e27b1565976235287cea8cf11856f99b55eff5b671d5d" => :sierra
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
