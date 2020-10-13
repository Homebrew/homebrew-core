class JujuWait < Formula
  include Language::Python::Virtualenv

  desc "Juju plugin for waiting for deployments to settle"
  homepage "https://launchpad.net/juju-wait"
  url "https://files.pythonhosted.org/packages/0c/2b/f4bd0138f941e4ba321298663de3f1c8d9368b75671b17aa1b8d41a154dc/juju-wait-2.8.4.tar.gz"
  sha256 "9e84739056e371ab41ee59086313bf357684bc97aae8308716c8fe3f19df99be"
  license "GPL-3.0-only"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "23e16db727916534057523094c7f841d0f51a5854b8904ca43a94b0ab82282c7" => :catalina
    sha256 "baa822973796ccf4b164e88722163276acc6b75d20e350fda003f06767dcf04f" => :mojave
    sha256 "d7bb2a808196dd05783f7a97c2e9bdfe2f24882db024f009b7b1d13aee881d10" => :high_sierra
  end

  depends_on "juju"
  depends_on "libyaml"
  depends_on "python@3.9"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Note: Testing this plugin requires a Juju environment that's in the
    # process of deploying big software. This plugin relies on those application
    # statuses to determine if an environment is completely deployed or not.
    system "#{bin}/juju-wait", "--version"
  end
end
