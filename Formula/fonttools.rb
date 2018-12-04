class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.33.0/fonttools-3.33.0.zip"
  sha256 "f809b33c9124f6b06c9915bedb8c7a28c8201028e55546995e997937aaa1dea4"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd9a84e39a47954b7fe9b2f118ae9c4e2e79ea2a516d3c218fc0a2f7e5523d34" => :mojave
    sha256 "ded0e0044b35c466a9b9ea330533a34e641bec15ed58705609f4ceddbf35381d" => :high_sierra
    sha256 "bb1cdda627764f7310dd45757b5caea24d12fbfeb3474cc3832777af1d46ced4" => :sierra
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
