class JujuWait < Formula
  include Language::Python::Virtualenv

  desc "Juju plugin for waiting for deployments to settle"
  homepage "https://launchpad.net/juju-wait"
  url "https://files.pythonhosted.org/packages/3d/c2/8cce9ec8386be418a76566fcd2e7dcbaa7138a92b0b9b463306d9191cfd7/juju-wait-2.6.2.tar.gz"
  sha256 "86622804896e80f26a3ed15dff979584952ba484ccb5258d8bab6589e26dd46d"
  revision 4

  bottle do
    cellar :any
    sha256 "161f3506996a9519a0494b1dd2c9e832f2455e19597a68665f0b444d00c6c8cf" => :high_sierra
    sha256 "9a863b25abf2bf8b1f48a1b1420183698113f21d4db987b2442855203a898c3a" => :sierra
    sha256 "7a6621f85da12560b95b18012a2c9e21acd0b3a89da45f621f68f9693139a172" => :el_capitan
  end

  depends_on "python"
  depends_on "libyaml"
  depends_on "juju"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/bd/da/0a49c1a31c60634b93fd1376b3b7966c4f81f2da8263f389cad5b6bbd6e8/PyYAML-4.2b1.tar.gz"
    sha256 "ef3a0d5a5e950747f4a39ed7b204e036b37f9bddc7551c1a813b8727515a832e"
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
