class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.35.2/fonttools-3.35.2.zip"
  sha256 "d6d3c156db470bd8feaf2421a0ea281c80ed7d1eeba32f5ccb4310f3d8fceffc"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ef15dda0492be6aadf9f05027725a49976c6f3427e915112cb46957d7b954e3" => :mojave
    sha256 "f72736fe62773a5fd777fcba2453b7c2050ccafdfd336c888a556137ec7d6fe6" => :high_sierra
    sha256 "3d51215bf8e15efa2fe6cfa4383db9fbf743074d50a83d73027da71cf1a82cef" => :sierra
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
