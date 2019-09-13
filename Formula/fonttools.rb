class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.0.1/fonttools-4.0.1.zip"
  sha256 "839e6315eccf6f4eb3d690f1448206e26db66491fe69e27bc1f34cd1c98372d1"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "80147cb8701601f10dc146d4c7dfbcbc75bf709c687abfbf0c4064361d93d711" => :mojave
    sha256 "b61d4f024e5da23dba1973c480ec82d02f016b5b8045b6e91e0670985ed4b6b4" => :high_sierra
    sha256 "31a45650a9dc1367f9135252df1084bcf0c280f1b040d8d44780a655e7e0052b" => :sierra
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
