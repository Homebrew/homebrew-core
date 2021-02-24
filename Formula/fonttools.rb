class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/63/f8/c26c7235dc2bb2b34a4898f938a0a65721aef9bc1b5992e1707520541a06/fonttools-4.20.0.zip"
  sha256 "afd051129dd546f81534c1d08b4fc118c0307d614f6fc5145d2e3e76bcfb7513"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dc0cbf2794254ed6bce6da5b10376a68f56cb41e464b65bc75c1a7a3e91da534"
    sha256 cellar: :any_skip_relocation, big_sur:       "7f9a907e2d1ccd58083f0a038e980bea7dc01ef78c5711827d068d73d6b1be94"
    sha256 cellar: :any_skip_relocation, catalina:      "f1846a1b1d0632e6750d08481e67906afa8a8aa135167889ce1985af7784e4dc"
    sha256 cellar: :any_skip_relocation, mojave:        "6d4068b1a30e83e6e576d8c4a04200fba2be8e105e1d9cd79ad59d73c40a38fb"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
    system bin/"ttx", "ZapfDingbats.ttf"
  end
end
