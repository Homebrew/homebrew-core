class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.43.1/fonttools-3.43.1.zip"
  sha256 "217176a154341c05c91a1b2f78f5534fb7ca14b84671ac73893e14578527888e"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bdf62edadd87e6d3f164a8edcae03db52a33e46774067fa96f83d60565abb093" => :mojave
    sha256 "6e7b938517d967162dd11eaca97914e1f98ae3cf74f7e49b0dcd93922a011557" => :high_sierra
    sha256 "0ffe8a8ba25b2832296e3ac7f1fc013df538d46b42fc23c0a0960a7a3b58bda5" => :sierra
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
