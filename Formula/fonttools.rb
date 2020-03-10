class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.4.1/fonttools-4.4.1.zip"
  sha256 "fab07ad31b4d24d7b9798453f678faa179906d29a3ad15bddb92496f1f9ea122"
  revision 1
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b86e2401eb4d2fa17c575b4cee04a5862fdcd31ac4fe68a40bb03550d1660b9" => :catalina
    sha256 "82a00184d499362f9344c1fbc45954a90388fd82499f356bcd2f6f4497b21cbb" => :mojave
    sha256 "48765d50a7430d867a4c8e17acb6f16d30624b16b8d5c809afca6265fa686cfe" => :high_sierra
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
