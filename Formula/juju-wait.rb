class JujuWait < Formula
  include Language::Python::Virtualenv

  desc "Juju plugin for waiting for deployments to settle"
  homepage "https://launchpad.net/juju-wait"
  url "https://files.pythonhosted.org/packages/d6/01/381cc24aabf820ff306b738a01b11aed5ac365a6438d46792f9fee2fe5f8/juju-wait-2.7.0.tar.gz"
  sha256 "1e00cb75934defa50a2cc404574d4b633049f1fa011a197dfac33e3071840e98"
  revision 1

  bottle do
    cellar :any
    sha256 "a969b35744d3fad4f45802d53bf1dd5da96eed56ae01e0ba6d246ea4b4a89a32" => :catalina
    sha256 "88d585b8cf738d97549f138d0fc49195d78e55ce4eaa4e2596e8e7af19827e68" => :mojave
    sha256 "d7b4c5a6f83f55f5f5084d6a2c58d8119923ee203f2770fb4affa3cebeefe96e" => :high_sierra
  end

  depends_on "juju"
  depends_on "libyaml"
  depends_on "python@3.8"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/3d/d9/ea9816aea31beeadccd03f1f8b625ecf8f645bd66744484d162d84803ce5/PyYAML-5.3.tar.gz"
    sha256 "e9f45bd5b92c7974e59bcd2dcc8631a6b6cc380a904725fce7bc08872e691615"
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
