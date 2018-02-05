class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.22.0/fonttools-3.22.0.zip"
  sha256 "01640dfbc0ba752181b21fe74240b8a7bbf7af75581737245836ada5565bd549"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb21d03c06af0a68116f36fd77ff9700a2aab6d0b8eba98deb7af83f49be134d" => :high_sierra
    sha256 "c0ada9d8b336cbbec39d6c97e49b63bc3866ae3f62777a3dddea17a8501a1696" => :sierra
    sha256 "77519957e9aa318d3802fee7fb8bc07c9347d481a938cd8980ea526d982bc3a8" => :el_capitan
  end

  option "with-pygtk", "Build with pygtk support for pyftinspect"

  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "pygtk" => :optional

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end
