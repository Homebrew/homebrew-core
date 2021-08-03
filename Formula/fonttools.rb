class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/bd/1e/5829f2b579fc0148500776cdf3ea59bc9d6358892cb43df6715d34fa6004/fonttools-4.26.1.zip"
  sha256 "2c7bbbcd5ee4e4d91af1001884c7bd9fb5bd29eac2754a16002f187afa584185"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "145697157c56c7205a1c5bd75dd4d361b1239963dabb8b907489ff13e582b01b"
    sha256 cellar: :any_skip_relocation, big_sur:       "d29741c1cec8303792bb8be461f3747fe7c47ad9fa8f9845f26858acd1f3101f"
    sha256 cellar: :any_skip_relocation, catalina:      "d29741c1cec8303792bb8be461f3747fe7c47ad9fa8f9845f26858acd1f3101f"
    sha256 cellar: :any_skip_relocation, mojave:        "d29741c1cec8303792bb8be461f3747fe7c47ad9fa8f9845f26858acd1f3101f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7aae8e422485e99a417215fc2366363de5dd126a638919855f1d4d81bb828ef5"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    on_macos do
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
    end
    on_linux do
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
