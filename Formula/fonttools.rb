class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.2.1/fonttools-4.2.1.zip"
  sha256 "1b780f008d8412eec58d17bbfafa43b34a8480ed607621d4383c0986fa2c097d"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6701c36434bc23a000ae74a7de1dabcc8c79d7836371753e09eb6cafbec654e" => :catalina
    sha256 "5035ac87ae08d70002d9876343308d478066f2e65fac5af2185abc5c53d17b8d" => :mojave
    sha256 "327fcdd17de25dfc9ffb10bba1d9ab235827b0d3361d2371f5f763c348ed5327" => :high_sierra
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
    system bin/"ttx", "ZapfDingbats.ttf"
  end
end
