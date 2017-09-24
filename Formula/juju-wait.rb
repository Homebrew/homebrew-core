class JujuWait < Formula
  include Language::Python::Virtualenv

  desc "Juju plugin for waiting for deployments to settle."
  homepage "https://launchpad.net/juju-wait"
  url "https://pypi.python.org/packages/96/82/6b1b566b75f668605469d9af220bed0104bd4dc12c66160771b32f3aab58/juju-wait-2.5.0.tar.gz"
  sha256 "05354b87e65b19a67176e470b4edf2588ae3ec301576b4a5214bc698c420671e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "17703a8fca9d4706d855d771822044a4f04cd803ce764417707b855cfef3f67d" => :high_sierra
    sha256 "14d7675bfaa400e2b070d3154b3b9c6fc2770d758616a3dd0226fb55d156c595" => :sierra
    sha256 "20b5b1bca90eaddac10a42671993d860c2edecdf805262fd6564267544298baa" => :el_capitan
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
