class JujuWait < Formula
  include Language::Python::Virtualenv

  desc "Juju plugin for waiting for deployments to settle"
  homepage "https://launchpad.net/juju-wait"
  url "https://files.pythonhosted.org/packages/d6/01/381cc24aabf820ff306b738a01b11aed5ac365a6438d46792f9fee2fe5f8/juju-wait-2.7.0.tar.gz"
  sha256 "1e00cb75934defa50a2cc404574d4b633049f1fa011a197dfac33e3071840e98"

  bottle do
    cellar :any
    sha256 "1bd151d68e2b3671a7f7a5089a6264358094049b8f0a01c1fcfe6278b039c72d" => :catalina
    sha256 "fa16c0c9ee4e4630473cead84377e6c0495013a25f9952e1000737ca11f7268a" => :mojave
    sha256 "2067d5af66824dc2100ddc6cbc2a758dd3d919dcb44035a4d6c7112aaf391fa0" => :high_sierra
    sha256 "46dadcf85332eaf1e80e044da7fb790ce32d65df5f79193253f4edb80d16c283" => :sierra
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
