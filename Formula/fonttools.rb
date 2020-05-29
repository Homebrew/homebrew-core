class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.11.0/fonttools-4.11.0.zip"
  sha256 "7fe5937206099ef284055b8c94798782e0993a740eed87f0dd262ed9870788aa"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "521ffb3cb2b8f87953294c04d108b83f2fe98a8bf45e79008d36f951314b88db" => :catalina
    sha256 "31b8da8b065732fbd80b9f5145f333e2f9d3c5652f3c7cdfab02eed70f8088c0" => :mojave
    sha256 "7673aa115c8e2672b6ba98c4938aeabc90cbd8b984eac5a63732c0ca239c5ca2" => :high_sierra
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
