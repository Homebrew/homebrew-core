class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/5a/a4/a97cff4c4af6764a04cc202299e5205b2e101cb1543bcaf9737be29f78ab/fonttools-4.34.4.zip"
  sha256 "9a1c52488045cd6c6491fd07711a380f932466e317cb8e016fc4e99dc7eac2f0"
  license "MIT"
  revision 1
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a68fcf914aa7731c16c0efc6aed98257c8c8fe9446e9ded5f6cac37f83dd36e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a68fcf914aa7731c16c0efc6aed98257c8c8fe9446e9ded5f6cac37f83dd36e"
    sha256 cellar: :any_skip_relocation, monterey:       "6dbdf1a2ffbd81ce74ce60b5dc61c1a2aa129e0eb48ab199521a144865b29f61"
    sha256 cellar: :any_skip_relocation, big_sur:        "6dbdf1a2ffbd81ce74ce60b5dc61c1a2aa129e0eb48ab199521a144865b29f61"
    sha256 cellar: :any_skip_relocation, catalina:       "6dbdf1a2ffbd81ce74ce60b5dc61c1a2aa129e0eb48ab199521a144865b29f61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5872c5f00ffb473a5e8b920f67aae7f7212cc299f2e15860059cbd9907b02d48"
  end

  depends_on "python@3.10"

  resource "Brotli" do
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
