class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/c6/38/54454a225deb3af95d369dc7fa5ad050ec27d0e7ed491f057c015f69c47e/fonttools-4.25.0.zip"
  sha256 "4c9e42265d48264da8a001ce94933fb90b69e035738ba7839be7357534aeab0b"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cce4badd2ebea6ef588b64d50bfe94968effe42fa6375ec84d1201bfad24fb16"
    sha256 cellar: :any_skip_relocation, big_sur:       "ce61f235ad4d19d9108484bec7cdd80e00f2d8b706480f6f30cea20e407b9a6d"
    sha256 cellar: :any_skip_relocation, catalina:      "ce61f235ad4d19d9108484bec7cdd80e00f2d8b706480f6f30cea20e407b9a6d"
    sha256 cellar: :any_skip_relocation, mojave:        "ce61f235ad4d19d9108484bec7cdd80e00f2d8b706480f6f30cea20e407b9a6d"
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
