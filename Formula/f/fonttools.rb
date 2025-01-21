class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/76/61/a300d1574dc381393424047c0396a0e213db212e28361123af9830d71a8d/fonttools-4.55.3.tar.gz"
  sha256 "3983313c2a04d6cc1fe9251f8fc647754cf49a61dac6cb1e7249ae67afaafc45"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8be8cc3dde82d6c900d6ba0834d1014317f94f94a61d2d99175949b3c002176"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e685bef10a03b3305f8bbdf1c2d267d0d61fa091f6a0872eb739911109c724f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd33a1a54d8b116805e4f3b039230a5089c6725a2a74e445c7a219e60a010f4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a09a5a7748cc323211d22945f4abadfcc7c903262e10ba121ad0b2b20721dbb"
    sha256 cellar: :any_skip_relocation, ventura:       "22870d3feec528c2a0885c5f8e6767af93e57404e5e964276e36f0ab3f665b30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "966a4fc505820f5a5d8ce84e2f6c5abc00b026625b0eec931dd84172e4cb19ff"
  end

  depends_on "python@3.13"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "zopfli" do
    url "https://files.pythonhosted.org/packages/5e/7c/a8f6696e694709e2abcbccd27d05ef761e9b6efae217e11d977471555b62/zopfli-0.2.3.post1.tar.gz"
    sha256 "96484dc0f48be1c5d7ae9f38ed1ce41e3675fd506b27c11a6607f14b49101e99"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath

      system bin/"ttx", "ZapfDingbats.ttf"
      assert_predicate testpath/"ZapfDingbats.ttx", :exist?
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
      assert_predicate testpath/"ZapfDingbats.woff2", :exist?
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
