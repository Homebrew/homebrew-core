class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/9b/86/1d53f4a83fdd67361e112fd9f92641e647a62d11daa0ae0edd7a353693a6/fonttools-4.35.0.zip"
  sha256 "1cfb335c0abdeb6231191dc4f9d7ce1173e2ac94b335c617e045b96f9c974aea"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "605e97d12433b61714411d8010e369652af17da55c5f42209b530f62c53bb1cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "722e50a7ab218b936435cf44c216bd79284a8136f4c5f5ee1b8de9d4b7afb57c"
    sha256 cellar: :any_skip_relocation, monterey:       "717cbad5a9b841a975954deab47e12c32ae535c326bcd0668d711252aa31496d"
    sha256 cellar: :any_skip_relocation, big_sur:        "877d1cd0b24e06dd8529bc25d34e48057a60110ad1e759336ebfa76ab0a32b89"
    sha256 cellar: :any_skip_relocation, catalina:       "96d38515ccb3175eaeff821f5a696a30a3ec4f3a596a90d82b6812c5ae1c78b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "504039c5a2357d5032c0c20264e9adb756b159b13b121ea0f332cf48742a94a7"
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
