class JujuWait < Formula
  include Language::Python::Virtualenv

  desc "Juju plugin for waiting for deployments to settle"
  homepage "https://launchpad.net/juju-wait"
  url "https://files.pythonhosted.org/packages/0c/2b/f4bd0138f941e4ba321298663de3f1c8d9368b75671b17aa1b8d41a154dc/juju-wait-2.8.4.tar.gz"
  sha256 "9e84739056e371ab41ee59086313bf357684bc97aae8308716c8fe3f19df99be"
  license "GPL-3.0-only"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e04f8b657da7e878dda77d9c31306708e062f3f917c6f31426da41ecbc8dbad5"
    sha256 cellar: :any,                 arm64_big_sur:  "755de97cf6751a7f122dab8c7333fc36010210f3e20a3869e6662a3686efac1c"
    sha256 cellar: :any,                 monterey:       "110669824c007b0ad6a05f5b387711779377bf83e0e4e5229d7925b277c69310"
    sha256 cellar: :any,                 big_sur:        "fadd2d52965a99d993bd11bf75de1b7e7373b4ce17c9af28118f8b211f1170d4"
    sha256 cellar: :any,                 catalina:       "9d08ba7ec7decac831dc8d38137d028caa99f3545ffb2c75c7c1f7a51539618f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53e1fa7c3e4fcaf849f6cdb515f63aeb5c12c2539b682b5cf3293b568ea35211"
  end

  depends_on "juju"
  depends_on "libyaml"
  depends_on "python@3.10"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # NOTE: Testing this plugin requires a Juju environment that's in the
    # process of deploying big software. This plugin relies on those application
    # statuses to determine if an environment is completely deployed or not.
    system "#{bin}/juju-wait", "--version"
  end
end
