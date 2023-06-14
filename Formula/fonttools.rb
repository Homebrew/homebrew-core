class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/eb/dd/0e1ab46e90938057fff61438a19fa45e0e857200f7408e3c816424fd1ef9/fonttools-4.40.0.tar.gz"
  sha256 "337b6e83d7ee73c40ea62407f2ce03b07c3459e213b6f332b94a69923b9e1cb9"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebd971d7bb20ca00ab49eee08d90fc24892e538b4f4c1435fe08e8d7e5e83ed6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57fc15409b1d7895f6c0adca5a1f989dd718bf54d610f030f0e7057a91f6ffca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b7c8af30ca69ccc71366fbe7cb8a70a7552fbd8b309c4333ac8adbee473eea1"
    sha256 cellar: :any_skip_relocation, ventura:        "28d28e8a40568bb1215c6954e4d0ea724f60f12305d4beb85eeed47831ed5aaa"
    sha256 cellar: :any_skip_relocation, monterey:       "d8b0d9ce8cee712686cdd66e0d56784be4d597d537de5ea234e6234f018c704d"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b848931be78d2c6d8db1db3dc062a42db7e7d083b7f9b995b9c50106fb903ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a7e56b0017980b8868469c40027331b2429b7d711a6a31bc9c68e67ef57915d"
  end

  depends_on "python@3.11"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
