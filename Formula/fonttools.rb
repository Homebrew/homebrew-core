class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.4.2/fonttools-4.4.2.zip"
  sha256 "9532ff305e43ba19cf78003ebc9742c2f3edb0001b1978ea135e0e13bb0dc85a"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4082e4a4664732108b58f90cb4dccac4f18afda8f8d8528bee54a2b5f03dd39b" => :catalina
    sha256 "03eae2ed4b35b659dd25174fcb55597b0429da559d3afff7f0ca3eedc69c3e16" => :mojave
    sha256 "44776de6f63e7b6e45b62e74968d90fd41d3b3ff5903cf4715a43899c87d8d3a" => :high_sierra
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
