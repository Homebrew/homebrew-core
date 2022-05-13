class JujuWait < Formula
  include Language::Python::Virtualenv

  desc "Juju plugin for waiting for deployments to settle"
  homepage "https://launchpad.net/juju-wait"
  url "https://files.pythonhosted.org/packages/0c/2b/f4bd0138f941e4ba321298663de3f1c8d9368b75671b17aa1b8d41a154dc/juju-wait-2.8.4.tar.gz"
  sha256 "9e84739056e371ab41ee59086313bf357684bc97aae8308716c8fe3f19df99be"
  license "GPL-3.0-only"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87e0c8b5441eff8bfa72f04efa8c49b0b3eb6236e0f53e4e7bdaa052ae88e1b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87e0c8b5441eff8bfa72f04efa8c49b0b3eb6236e0f53e4e7bdaa052ae88e1b3"
    sha256 cellar: :any_skip_relocation, monterey:       "2496e4760d1ed75a5b6a7bbfdda55ef7da3a770506a3f37cf45c2b473e6f7c7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2496e4760d1ed75a5b6a7bbfdda55ef7da3a770506a3f37cf45c2b473e6f7c7f"
    sha256 cellar: :any_skip_relocation, catalina:       "2496e4760d1ed75a5b6a7bbfdda55ef7da3a770506a3f37cf45c2b473e6f7c7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65cd144e6f87645a854ef1f1690f49faec1a4d38cc334998f896446d83d2c1ce"
  end

  depends_on "juju"
  depends_on "libyaml"
  depends_on "python@3.10"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

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
