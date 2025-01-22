class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/13/8d/8912cdde6a2b4c19ced69ea5790cd17d1c095a3c0104c1c936a1de804a64/fonttools-4.55.4.tar.gz"
  sha256 "9598af0af85073659facbe9612fcc56b071ef2f26e3819ebf9bd8c5d35f958c5"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a712f530b262ee554ae721c4f2af762e869f468d06e3ba07790033754d37dcce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cbc3dbd536af6a4483ca097afc89d5981038b8c893daea5d56632b6cd93ddc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9d64cd6b98ffb1481fbc1df67bf67578f8a1c561e735b16eca0067fc389adf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c484f4ec5c85702dadbf5df570b1917bca57a03eb3b1cc197d76b0c1bfb734f"
    sha256 cellar: :any_skip_relocation, ventura:       "40c3c6b60e30f695d86c05f606cb5def89e253eec63381bd3e3f23e72911012d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e11c13528c405726306d523761db824f69e4dc9b29a417badb3daa6f09c8e6c"
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
