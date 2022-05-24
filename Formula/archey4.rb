class Archey4 < Formula
  include Language::Python::Virtualenv

  desc "Simple system information tool written in Python"
  homepage "https://github.com/HorlogeSkynet/archey4"
  url "https://files.pythonhosted.org/packages/be/f1/48885ef271b76ac590e239c04531af48009b85b54b60c1d2afba9b0bf463/archey4-4.13.4.tar.gz"
  sha256 "9813ed0a1d5131756375e4113e6b158723d299353dab3d51b6ac0420af402e2c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41ddb1507784fabcc850020343fd218a3550a45b837a3ef67467cb52945c873c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45e747c8cdf4b78d7600910803f3651694472044a6228222507bf07c99ec3a12"
    sha256 cellar: :any_skip_relocation, monterey:       "954a64e2166de9a4819c80b5af70de71c466ac4266116580ade432d31bcb564d"
    sha256 cellar: :any_skip_relocation, big_sur:        "af7eaa81198e4469d4f929dfb0710f17cb9071201929791c6e5b107343c6e86a"
    sha256 cellar: :any_skip_relocation, catalina:       "2d54f4f054f4c28b2622c158cf30ad023100994e245490eea9307fda36529ba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac16d29ad8c1354679cebb649399298c6b01975f75fe6cc601076343d712b83a"
  end

  depends_on "python@3.10"

  conflicts_with "archey", because: "both install `archey` binaries"

  resource "distro" do
    url "https://files.pythonhosted.org/packages/b5/7e/ddfbd640ac9a82e60718558a3de7d5988a7d4648385cf00318f60a8b073a/distro-1.7.0.tar.gz"
    sha256 "151aeccf60c216402932b52e40ee477a939f8d58898927378a02abbe852c1c39"
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
