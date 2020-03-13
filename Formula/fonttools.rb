class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.4.3/fonttools-4.4.3.zip"
  sha256 "f5b014cc20f26bc812818330e3ac00db612721d1f24f98db42b40c307c2d9205"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c8accbe8540160d50f5ac044e5e8421b8384e30c20098de380ae85d5f8c8cad6" => :catalina
    sha256 "77243b3f6916484f3692f05b2274af6c9052247601c80c5b315b9621fc414080" => :mojave
    sha256 "cad055502ef26de090263b0cfd60241d48eb622f9fe39c5cc535affbfc5cc6d6" => :high_sierra
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
