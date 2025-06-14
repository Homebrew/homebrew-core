class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/2e/5a/1124b2c8cb3a8015faf552e92714040bcdbc145dfa29928891b02d147a18/fonttools-4.58.4.tar.gz"
  sha256 "928a8009b9884ed3aae17724b960987575155ca23c6f0b8146e400cc9e0d44ba"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "913dc4d1814468097c71160790d242d3bf92032cbe9209cbb31484d2cb16c9fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5289c760f408a539132a031cd30a7602d7e097d3dbab7874c0fc932454c4d48e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6509b1ababd09f09dc685c64c55621995da27f581726091f206ec13c1d836547"
    sha256 cellar: :any_skip_relocation, sonoma:        "d76f262cfc527af47eb98ad820fe0c4582f1a9bfdb93f6d10e4cf5941d628b1b"
    sha256 cellar: :any_skip_relocation, ventura:       "48541c30ae606dddc53cc20a1d1a2b33bdccb4714694a8b09a1a6d82a5d4ac67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6db31cc9c66af48c7bb4cd2170f6cfb76828410c6b27c3d7e383a08d43821356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "836f3baa6adadaf8446045936cb268dce81497e45ae4a8211fa91980dbdc7a36"
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
