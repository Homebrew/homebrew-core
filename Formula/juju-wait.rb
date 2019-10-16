class JujuWait < Formula
  include Language::Python::Virtualenv

  desc "Juju plugin for waiting for deployments to settle"
  homepage "https://launchpad.net/juju-wait"
  url "https://files.pythonhosted.org/packages/4c/ee/1a4b3298afd01f276e37dbd3f8d5a42478fb049f08f6255ca2742f7aab9f/juju-wait-2.6.4.tar.gz"
  sha256 "c1dd38c2525fc26d1e89739f9a932aebfd2c1e238e96c980f26527522e7111bf"

  bottle do
    cellar :any
    sha256 "1bd151d68e2b3671a7f7a5089a6264358094049b8f0a01c1fcfe6278b039c72d" => :catalina
    sha256 "fa16c0c9ee4e4630473cead84377e6c0495013a25f9952e1000737ca11f7268a" => :mojave
    sha256 "2067d5af66824dc2100ddc6cbc2a758dd3d919dcb44035a4d6c7112aaf391fa0" => :high_sierra
    sha256 "46dadcf85332eaf1e80e044da7fb790ce32d65df5f79193253f4edb80d16c283" => :sierra
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
