class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.35.2/fonttools-3.35.2.zip"
  sha256 "d6d3c156db470bd8feaf2421a0ea281c80ed7d1eeba32f5ccb4310f3d8fceffc"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3282a9e45799852f29315bd8eb5c96d1a9fbc00ee9d7834e24eda043fa5c867" => :mojave
    sha256 "e3337fa686291a8528035b30dabfb40ae932e2b53e6f19ed11a6a9376049e9b7" => :high_sierra
    sha256 "1d80a45f8cc168abeb44978437f74c5569cb5cc2f318835975dc429d9fbd3d55" => :sierra
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
