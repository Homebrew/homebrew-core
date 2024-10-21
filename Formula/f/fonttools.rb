class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/11/1d/70b58e342e129f9c0ce030029fb4b2b0670084bbbfe1121d008f6a1e361c/fonttools-4.54.1.tar.gz"
  sha256 "957f669d4922f92c171ba01bef7f29410668db09f6c02111e22b2bce446f3285"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27a178d9ea6dd869b03063a53f7340550ebab79ae9f3e2fe3f06df50816f2641"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02d2714a212dfebaae3bbd325dc5e7b0c8830f7c9e6d7d4d29b41b0f1caf5173"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8be2fdd1ca43645f5b5255d8075cecdc262d67084e479f5f2b893cce6ba78ebd"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae83bfd089b5ee7eda8a32aa58e4ea6a3d75c768ba97a6f295f4e47d144e933a"
    sha256 cellar: :any_skip_relocation, ventura:       "fffc4004399f8dba361085251781deb797c4daf9e04740f759ddb7dee38e241c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de8d3e366d9ebc7e321c7b71cb9634f4516a3eef9769f55338fe57a98c59ff65"
  end

  depends_on "python@3.13"

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
