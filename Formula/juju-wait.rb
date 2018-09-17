class JujuWait < Formula
  include Language::Python::Virtualenv

  desc "Juju plugin for waiting for deployments to settle"
  homepage "https://launchpad.net/juju-wait"
  url "https://files.pythonhosted.org/packages/3d/c2/8cce9ec8386be418a76566fcd2e7dcbaa7138a92b0b9b463306d9191cfd7/juju-wait-2.6.2.tar.gz"
  sha256 "86622804896e80f26a3ed15dff979584952ba484ccb5258d8bab6589e26dd46d"
  revision 4

  bottle do
    cellar :any
    rebuild 1
    sha256 "15fa3359787a282c544f5127b59768de35d1de696eeb373581d5b2138e0d0ecc" => :mojave
    sha256 "2802694404b542f013d7d527060a824d0d23c4ed8df2afa65fbc9ae4b5fe7ad1" => :high_sierra
    sha256 "8d5e2242690889d4c8dee8af054d3ca7ba91f4d75e2f3d9e7bcb1cd553ec4f81" => :sierra
    sha256 "d3947255f7a166e1416c61ed8badf8d1bbb247afd62f12b9bf96d3a16ff7bee9" => :el_capitan
  end

  depends_on "juju"
  depends_on "libyaml"
  depends_on "python"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
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
