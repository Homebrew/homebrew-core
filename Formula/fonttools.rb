class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.43.0/fonttools-3.43.0.zip"
  sha256 "147e047779c57b66ce827f04b9336f040b19f38b3164a688311e7de7af7180fa"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ccef6063dbd1009a7801cd9b7feb23c9c2c5c1e5fadeb936889070bf26f1d6ef" => :mojave
    sha256 "886cbaf629dcdff21e61d44ab75dacf960fc5d282be51f643145112034f45109" => :high_sierra
    sha256 "c658ec13b72e9ce4b5dfa5b560cf5cbdbd19104ca4e0d050a173e8f11722f94e" => :sierra
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
