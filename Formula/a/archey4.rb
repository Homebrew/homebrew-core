class Archey4 < Formula
  include Language::Python::Virtualenv

  desc "Simple system information tool written in Python"
  homepage "https://github.com/HorlogeSkynet/archey4"
  url "https://files.pythonhosted.org/packages/b3/76/21850b7c2b5967326c13fac40a60e9d49295e971ec5b5398780da9d5ee04/archey4-4.14.2.0.tar.gz"
  sha256 "afbc9f66e0ff85bfff038b9a8a401cb269a28a9024b2ce29ad382e07443eae9d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bd260d2639f15b056c03fc39374c84f7206fcbc8538503fa7f16e6506651397"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d91094554972143c4283b1ad730014b99aa9ef07cf240acfafc9f173d145086"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "480320e29c124aaf0b87287da851d1013c40fcf4ab1ef4ba9f6f6b73f6fe6987"
    sha256 cellar: :any_skip_relocation, ventura:        "4efa81c41fe2e6a772bdff68fe59d602ef6686887eb1d431b690e02ad4b5e6a3"
    sha256 cellar: :any_skip_relocation, monterey:       "798fa44e961cade8a03c230662ba060262a350f9943cba42add46603d695959d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fde54a24db8385feafad7791a11b6047e1b6b658526ed9e6edb01aaffd10490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41647f3b70ab43873f22623333be083aeb62e447e2d0b6d885dc13b1e013c1c1"
  end

  depends_on "python@3.11"

  resource "distro" do
    url "https://files.pythonhosted.org/packages/4b/89/eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398/distro-1.8.0.tar.gz"
    sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/a6/91/86a6eac449ddfae239e93ffc1918cf33fd9bab35c04d1e963b311e347a73/netifaces-0.11.0.tar.gz"
    sha256 "043a79146eb2907edf439899f262b3dfe41717d34124298ed281139a8b93ca32"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match(version.to_s, shell_output("#{bin}/archey -v"))
    assert_match(/BSD|Linux|macOS/i, shell_output("#{bin}/archey -j"))
  end
end
