class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/9b/86/1d53f4a83fdd67361e112fd9f92641e647a62d11daa0ae0edd7a353693a6/fonttools-4.35.0.zip"
  sha256 "1cfb335c0abdeb6231191dc4f9d7ce1173e2ac94b335c617e045b96f9c974aea"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "135e2c16af14bebffb1b58c481d96825958c4ec7daea49c4711fb58b3fc0c538"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d90d82e7d43a6282aeb248c1624a86a620065786e4e696711610fc9a2342499"
    sha256 cellar: :any_skip_relocation, monterey:       "ae724071e809652825d39cf9f1c43cb38aeecb02a0b618203fd471621d13512d"
    sha256 cellar: :any_skip_relocation, big_sur:        "75125b709f96808235e01b83f5d6177429ef1a9702e3506c953449b8b966378d"
    sha256 cellar: :any_skip_relocation, catalina:       "19683c71a829684088c4268c1a2004e3240469c757be1046424fb7b168dcc3ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63cf5593bc2554dc7f95a4dce6aab2819c27476fecf891b5610751584e89e447"
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
