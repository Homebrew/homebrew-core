class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.34.2/fonttools-3.34.2.zip"
  sha256 "9fa6596ec04410dc75f2b9a5df9ca71abac85a7a5a8502f57cc72166a5401aaa"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "601bb5a56de8f3be85b661e7e3dcdb9721430a907e837eed9440679a41ef4c6b" => :mojave
    sha256 "05e6fac3b310e8ccbefe121c0b15ec3888d4608d05ebe5ffa77079309a800b6b" => :high_sierra
    sha256 "9d8034bf2aad9435ed0f2f12a3ea0cd59bfdd1ac59c54b546fd5c5a934111099" => :sierra
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
