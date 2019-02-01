class JujuWait < Formula
  include Language::Python::Virtualenv

  desc "Juju plugin for waiting for deployments to settle"
  homepage "https://launchpad.net/juju-wait"
  url "https://files.pythonhosted.org/packages/4c/ee/1a4b3298afd01f276e37dbd3f8d5a42478fb049f08f6255ca2742f7aab9f/juju-wait-2.6.4.tar.gz"
  sha256 "c1dd38c2525fc26d1e89739f9a932aebfd2c1e238e96c980f26527522e7111bf"

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
