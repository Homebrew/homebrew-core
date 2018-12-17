class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.34.2/fonttools-3.34.2.zip"
  sha256 "9fa6596ec04410dc75f2b9a5df9ca71abac85a7a5a8502f57cc72166a5401aaa"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "50410b23cc5572752d5149ab3467a3ef4e5c55a0859be8f8fbe11c5225c827a7" => :mojave
    sha256 "fe36237d392a1bede4967e413c9480843a61f46a7961ad469d06d15a388104cd" => :high_sierra
    sha256 "e1914c401104e4b75b6e53d14dc70605fc328e036866b04d2ae5789eafad6830" => :sierra
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
