class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/3e/7a/30c581aeaa86d94e7a29344bccefd2408870bf5b0e7640b6f4ffede61bd0/fonttools-4.58.1.tar.gz"
  sha256 "cbc8868e0a29c3e22628dfa1432adf7a104d86d1bc661cecc3e9173070b6ab2d"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "588bfcf36f5f17eabc691520fc83c5c1c839bdc65bfe4303212f80a9ee703892"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c21a428411bfd83dd48be7699d80fa62beaf2346391bd4e28b2af423441fe99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "206625e701b9b8466e3bcf1890b50845e78e77d707f112492514b910ec318fa9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d650913fe4d04925d4c05b4b4b12cb0239d25721ad9bd9866b2999b42affe550"
    sha256 cellar: :any_skip_relocation, ventura:       "689448e8a968adc032cc59efc0a16713b93f076a0fb6b5054b53e9dc959d9d60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "654a0d82ae42fb0f15848299042e12c2028ba0b778c47c41047b87fbbea7d2b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "435d6ac0e8dbbacf8252429d9c1f563d5106f008caf237eccddb883417a00489"
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
      assert_path_exists testpath/"ZapfDingbats.ttx"
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
      assert_path_exists testpath/"ZapfDingbats.woff2"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
