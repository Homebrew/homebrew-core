class JujuWait < Formula
  include Language::Python::Virtualenv

  desc "Juju plugin for waiting for deployments to settle"
  homepage "https://launchpad.net/juju-wait"
  url "https://files.pythonhosted.org/packages/0c/2b/f4bd0138f941e4ba321298663de3f1c8d9368b75671b17aa1b8d41a154dc/juju-wait-2.8.4.tar.gz"
  sha256 "9e84739056e371ab41ee59086313bf357684bc97aae8308716c8fe3f19df99be"
  license "GPL-3.0-only"
  revision 3

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02a5b44bd00be30c7637fa792cda345136a29314e7b62168495c44d7c092eb03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02a5b44bd00be30c7637fa792cda345136a29314e7b62168495c44d7c092eb03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02a5b44bd00be30c7637fa792cda345136a29314e7b62168495c44d7c092eb03"
    sha256 cellar: :any_skip_relocation, ventura:        "6e14483aeeb4bb6b08f5b70ec193830c26ea765f80314f8637a8a160d39d6aad"
    sha256 cellar: :any_skip_relocation, monterey:       "6e14483aeeb4bb6b08f5b70ec193830c26ea765f80314f8637a8a160d39d6aad"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e14483aeeb4bb6b08f5b70ec193830c26ea765f80314f8637a8a160d39d6aad"
    sha256 cellar: :any_skip_relocation, catalina:       "6e14483aeeb4bb6b08f5b70ec193830c26ea765f80314f8637a8a160d39d6aad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35a3b784c741f07c02b34efaa11164ddc4ff26795e666a37edbac31cd2567260"
  end

  depends_on "juju"
  depends_on "python@3.11"
  depends_on "pyyaml"

  def install
    virtualenv_install_with_resources
  end

  test do
    # NOTE: Testing this plugin requires a Juju environment that's in the
    # process of deploying big software. This plugin relies on those application
    # statuses to determine if an environment is completely deployed or not.
    system "#{bin}/juju-wait", "--version"
  end
end
