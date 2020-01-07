class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.2.3/fonttools-4.2.3.zip"
  sha256 "da069660a5074a538729aa908b25ceab5fb8bd39e0bf6c0c21b5e6405672c8c5"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd9cf2664da6e6f2856aa22c198ffe8771d759eeab92c73533939bd15385256c" => :catalina
    sha256 "ae216d8be51bda5c55acee93cc957389f0f2d527bfaea897ce2743d3e9989994" => :mojave
    sha256 "70745e14602de083a80f93f65416e24069882311a34a9e348f085b2c8ccb4dec" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
    system bin/"ttx", "ZapfDingbats.ttf"
  end
end
