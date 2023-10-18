class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/43/bc/6051ee22b88c5d9d39ea68e8e2422d3036d9b52ac2afc559f7397d59bc64/fonttools-4.43.1.tar.gz"
  sha256 "17dbc2eeafb38d5d0e865dcce16e313c58265a6d2d20081c435f84dc5a9d8212"
  license "MIT"
  revision 1
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec1a18997dcb085caa3939dcf391ad82ddd7f07d2ab67e8cd56488656b617f44"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d5b17d13881b31b5055765c4a758347e496fb05c1be952c113d7d25adb0ebee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ea5298e3028bc3579af0c370d6eb5b10344795e7c817f1666878adf7d000fe2"
    sha256 cellar: :any_skip_relocation, sonoma:         "d60eff4baa65f09775f6d55f59b3677d50c5921ae34ac8329e3c6c3cff0922ab"
    sha256 cellar: :any_skip_relocation, ventura:        "9706063c6a52b4c1d31b0acbe5a00c7739429228c460ab0dac04574df76d5c52"
    sha256 cellar: :any_skip_relocation, monterey:       "9f9a917c75e95101a1dd49186c11eca0eedf2f12291bf2ee92912a282f720394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8241317a2eb9d7e6c2f330550d0480855ac8c3f1f2ac1ecc9c821c853fcf7e99"
  end

  depends_on "python@3.12"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
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
