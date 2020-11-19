class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.17.1/fonttools-4.17.1.zip"
  sha256 "7097b194babc05c8decfff6cbc81b184221fdcfbda568630fe441c63dadb3ab4"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "afad58dd43205ef48b3a08fa70e48354587908e5b3686a87c35c7d230f252009" => :big_sur
    sha256 "1fcd7c9819a79f6f7faed1d896d0e0a38b8fdd48207eb404e8fc3e0511b8476a" => :catalina
    sha256 "38524787ece984785c3aae4fa79230e0ee4a257338c17533b0e8354d095683b9" => :mojave
    sha256 "38d21a6bbb9cad92bf89e60ece24053788f15ad7f5a8ffae7255a3f2ca1528ae" => :high_sierra
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
    system bin/"ttx", "ZapfDingbats.ttf"
  end
end
