class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.4.0/fonttools-4.4.0.zip"
  sha256 "20116fd6b2a9c80d325281ee5f786374d9543f56dff1a441b8ecf1dcad09a262"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "17c1ba66fb5d9ad6a57f914b09c7e7a3c58f90e2f13dcb4367b19f3872897b18" => :catalina
    sha256 "529885e154a585b98d768b5f987cb7030ac1309aaddb8ab99d48206ea20200e4" => :mojave
    sha256 "8f44c27fc8075fa8e9b5fbf7e61d6a6c36b203f4ae9060b2b2ff365ad57a25b7" => :high_sierra
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
