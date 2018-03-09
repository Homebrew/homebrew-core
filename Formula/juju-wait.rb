class JujuWait < Formula
  include Language::Python::Virtualenv

  desc "Juju plugin for waiting for deployments to settle"
  homepage "https://launchpad.net/juju-wait"
  url "https://files.pythonhosted.org/packages/3d/c2/8cce9ec8386be418a76566fcd2e7dcbaa7138a92b0b9b463306d9191cfd7/juju-wait-2.6.2.tar.gz"
  sha256 "86622804896e80f26a3ed15dff979584952ba484ccb5258d8bab6589e26dd46d"
  revision 3

  bottle do
    cellar :any
    sha256 "9c64f34340bb1242114cc15949d94b3dafab6fe3bfd234890b6acc1816044d04" => :high_sierra
    sha256 "75f8af12426e2eb7264278d803f55a2df3f0a2224caeecd27deb36a328e648a5" => :sierra
    sha256 "c20694b7ed303804abbfbf524dcbead7fec5f8552913365dffe8757c88bab112" => :el_capitan
  end

  depends_on "python"
  depends_on "libyaml"
  depends_on "juju"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
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
