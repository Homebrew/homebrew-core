class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.14.0/fonttools-4.14.0.zip"
  sha256 "65744b52eee9da4e6ece77e0f8be1f79ab75f30d0b161ce667e9e2e2ed00b0d1"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f24a468a043db8f42265a1ec1c0639370b7168942b6f8a315f63fec3183bbc71" => :catalina
    sha256 "35a40f39c9b448ec0643435ad4efe679647051116b18635157d6f60afa64fedb" => :mojave
    sha256 "96ff2dda5bf3aeaf0aaf8dd29e20aa4b0592d3b0a38c5c58abaf8433e4578928" => :high_sierra
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
