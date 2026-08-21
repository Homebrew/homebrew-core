class Mat2 < Formula
  include Language::Python::Virtualenv

  desc "Metadata anonymization toolkit"
  homepage "https://github.com/jvoisin/mat2"
  url "https://files.pythonhosted.org/packages/01/3d/53616b3b1070f284a196147360f3a6179fb08d0362e7cee8c41d91c834c8/mat2-0.15.0.tar.gz"
  sha256 "0732df32ebbd800e3a680339fa049c96624e59430c9ddbf4136ad82459ef6231"
  license "LGPL-3.0-or-later"

  # FIXME: Fails trying to resolve pygobject as pip tries compiling it but cannot find cairo
  no_autobump! because: "`update-python-resources` cannot determine dependencies"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3994d3c3034d60f2d69cbc9c1da795a49742bcac3d36869d75f028245f267354"
  end

  depends_on "exiftool"
  depends_on "ffmpeg"
  depends_on "gdk-pixbuf"
  depends_on "librsvg"
  depends_on "poppler"
  depends_on "py3cairo" => :no_linkage
  depends_on "pygobject3" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "pygobject"

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/df/70/1675da133ea92227da41bf5b24e1c66be597ff736a1533ade41da986852f/mutagen-1.48.1.tar.gz"
    sha256 "8f95637ab9f6f305cec6bd1294e197debe207998e3e068596563c74f86b0a173"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mat2", "-l"
  end
end
