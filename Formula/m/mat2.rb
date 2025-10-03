class Mat2 < Formula
  include Language::Python::Virtualenv

  desc "Metadata anonymization toolkit"
  homepage "https://0xacab.org/jvoisin/mat2"
  url "https://files.pythonhosted.org/packages/ce/53/da9720bf3d8a3419e2d337ba0d12817c75578ada4ec1f161fc602dd2ed1d/mat2-0.13.5.tar.gz"
  sha256 "d7e7c4f0f0cfcf8bd656f97919281d0c6207886d84bdfdbb192c152ebf91fe19"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7b534040135d940e613435f419dd0556e98b876b3ff9364d67dc001ac3412ec7"
  end

  depends_on "exiftool"
  depends_on "ffmpeg"
  depends_on "gdk-pixbuf"
  depends_on "librsvg"
  depends_on "poppler"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.13"

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/81/e6/64bc71b74eef4b68e61eb921dcf72dabd9e4ec4af1e11891bbd312ccbb77/mutagen-1.47.0.tar.gz"
    sha256 "719fadef0a978c31b4cf3c956261b3c58b6948b32023078a2117b1de09f0fc99"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mat2", "-l"
  end
end
