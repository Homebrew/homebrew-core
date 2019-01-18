class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.36.0/fonttools-3.36.0.zip"
  sha256 "8fe280c6da84ed24345e23cae34e4dd41afed33e50eb03e1ffa407ca3ae0c598"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa6fd71580288a241cb9bb5fea418e184d74a6221b21aa7841429083ce62a87e" => :mojave
    sha256 "7689e4e2b6f467666b5a5a348756cacb8107f9f16eb13de9d693c201272a1343" => :high_sierra
    sha256 "cf8dffd868953462548091cb46cd43e7d62984338e111ab57c7de07e3cfc2c3b" => :sierra
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
