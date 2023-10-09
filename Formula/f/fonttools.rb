class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/43/bc/6051ee22b88c5d9d39ea68e8e2422d3036d9b52ac2afc559f7397d59bc64/fonttools-4.43.1.tar.gz"
  sha256 "17dbc2eeafb38d5d0e865dcce16e313c58265a6d2d20081c435f84dc5a9d8212"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9722530a2bc6bc22c22b3e2e2c80bb88cedbee826711fc7e1fc494be876e849"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad76117dd49caf7279dbe84f8c0fe77981353e2fd80c226cc051687569149518"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2795a349a88224ebc3d9cc0fa648f09f0b8bd70292122a0fa9ee3de8b831769"
    sha256 cellar: :any_skip_relocation, sonoma:         "ade256fc430114ae2b91b1a49ae78611f55083a620de20fbb90cd05f72d12731"
    sha256 cellar: :any_skip_relocation, ventura:        "42f1277fea70d5bfc5b2c9fd381c064fc0b08f69eedc10c40ad7c90bbd3ac2df"
    sha256 cellar: :any_skip_relocation, monterey:       "5d4dd4d52adf8e6236712a6b6d2b83a51f6b28171ccf518f66e5447271cd44f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "033a0eea986c0cc4192336caa6007e7b6a94aade8805c7c395c69efabe17ee2d"
  end

  depends_on "python@3.11"

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
