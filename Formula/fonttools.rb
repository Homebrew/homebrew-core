class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.0.0/fonttools-4.0.0.zip"
  sha256 "9415fda795f4ff8e89d41ab907388ec5a4c236f4774ea65a746d8c1e4e839d3d"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1aa10dd2690e9936c6b1b91eec172e413ec624574af235f1ff74756d5069f0a5" => :mojave
    sha256 "f83aa14daa70d975757ad6ac8d8f41f104b43a72c69393e44af78033f7b88e32" => :high_sierra
    sha256 "ee29ddf4263c764c7a98477a2350aa7cf3e229105d931b319c9815584e87c446" => :sierra
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
