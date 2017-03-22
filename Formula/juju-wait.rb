class JujuWait < Formula
  include Language::Python::Virtualenv

  desc "juju-wait, Juju plugin for waiting for deployments to settle."
  homepage "https://launchpad.net/juju-wait"
  url "https://pypi.python.org/packages/96/82/6b1b566b75f668605469d9af220bed0104bd4dc12c66160771b32f3aab58/juju-wait-2.5.0.tar.gz"
  sha256 "05354b87e65b19a67176e470b4edf2588ae3ec301576b4a5214bc698c420671e"

  bottle do
    cellar :any
    sha256 "2f286917e60870d00a44d30e7bcda422555494f3357424a9c2f8297b4daf8a35" => :sierra
    sha256 "c4e02d209d4ecd993f270a1460f406f296a6624f0354e4baffd8d865d41c5d6e" => :el_capitan
    sha256 "58f505e114f5d0d766845b90381e93c8f7c5d7600575bb8333e07d8187371c9e" => :yosemite
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
    system "#{bin}/juju-wait", "--version"
  end
end
