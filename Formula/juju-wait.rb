class JujuWait < Formula
  include Language::Python::Virtualenv

  desc "Juju plugin for waiting for deployments to settle"
  homepage "https://launchpad.net/juju-wait"
  url "https://pypi.python.org/packages/3d/c2/8cce9ec8386be418a76566fcd2e7dcbaa7138a92b0b9b463306d9191cfd7/juju-wait-2.6.2.tar.gz"
  sha256 "86622804896e80f26a3ed15dff979584952ba484ccb5258d8bab6589e26dd46d"

  bottle do
    cellar :any
    sha256 "638bebc1e82aa89779892f07079d8f512030f9a10e106b8468adad33eb7d8846" => :high_sierra
    sha256 "d742459b613fba6e91634641b10f7f9a87994eaba3098573acab9fc11f11622a" => :sierra
    sha256 "8e776297c6d7477122efbc04b0a8d45b4bae4e32613928f76e217b2888a2ebdb" => :el_capitan
  end

  depends_on :python3
  depends_on "libyaml"
  depends_on "juju"

  resource "pyyaml" do
    url "https://pypi.python.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
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
