class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/67/ac/d7bf44ce57ff5770c267e63cff003cfd5ee43dc49abf677f8b7067fbd3fb/fonttools-4.50.0.tar.gz"
  sha256 "fa5cf61058c7dbb104c2ac4e782bf1b2016a8cf2f69de6e4dd6a865d2c969bb5"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f5a3c9cc58e6b1388dfaeb55ae889c6321ca7f698fb784c77b228a39f2ab330"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "634a69af74e50380d26fa3492dad1fa3c5d3bab3989f2691033a962523ddfc9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "695bac871b2a7151b0121964cb1919d5bf1c8e026f4fc14f69334c1c872c5127"
    sha256 cellar: :any_skip_relocation, sonoma:         "41048c4b0ec83161a66d312c2a91b136ae1c3ccdd845e195fce28429e008396e"
    sha256 cellar: :any_skip_relocation, ventura:        "4138b6cef684a12cea36cfb9d26d67a4cf2475d478aeac387f60adafcd351fbc"
    sha256 cellar: :any_skip_relocation, monterey:       "13ef3dccdf3d8663ed0c064ef83fcfa3eb0df0e2787f1bd33ee757e6ef9f01a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0246d15f6cacc384c1df35b2c50852f24c604261d4d067c22a3e7fea19885f46"
  end

  depends_on "python@3.12"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "zopfli" do
    url "https://files.pythonhosted.org/packages/92/d8/71230eb25ede499401a9a39ddf66fab4e4dab149bf75ed2ecea51a662d9e/zopfli-0.2.3.zip"
    sha256 "dbc9841bedd736041eb5e6982cd92da93bee145745f5422f3795f6f258cdc6ef"
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
