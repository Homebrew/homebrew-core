class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.2.3/fonttools-4.2.3.zip"
  sha256 "da069660a5074a538729aa908b25ceab5fb8bd39e0bf6c0c21b5e6405672c8c5"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "689049352b7014537b3e0dd0acb4364a11eba2a1dfd245aabb3276eee26312b2" => :catalina
    sha256 "c079ba0455423a2389a410e7307c2c945144e270211525cff83f6e2f94a628ff" => :mojave
    sha256 "ea0006f665d8468a13dd71005cba0c127b9316bada39dc988f23540f89b44828" => :high_sierra
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
