class JujuWait < Formula
  include Language::Python::Virtualenv

  desc "Juju plugin for waiting for deployments to settle"
  homepage "https://launchpad.net/juju-wait"
  url "https://files.pythonhosted.org/packages/0c/2b/f4bd0138f941e4ba321298663de3f1c8d9368b75671b17aa1b8d41a154dc/juju-wait-2.8.4.tar.gz"
  sha256 "9e84739056e371ab41ee59086313bf357684bc97aae8308716c8fe3f19df99be"
  license "GPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c91fa90978e376e52e9bcadc23a86103d4ac976f372917095d22bed638ae6d14"
    sha256 cellar: :any,                 arm64_big_sur:  "e6b5a2374dcc6b496d184050039dcb233fdc695219518949ccb7b9d65ca98ef6"
    sha256 cellar: :any,                 monterey:       "99c4f93f810eb1a635f0b146d001d415013da37be2932b38771aa6399a8e4e5c"
    sha256 cellar: :any,                 big_sur:        "6e73b48dd92446f5cb69ec22117b9907aeff53ea52524fc5a2a095425430e5a3"
    sha256 cellar: :any,                 catalina:       "82f581e595e843682782737000c28646f59ce7ceda2572a094c616aeddf26709"
    sha256 cellar: :any,                 mojave:         "3d09fe21c6290f6a055cae35c06e4cdd7682111b295eea2551430df1f618b3d0"
    sha256 cellar: :any,                 high_sierra:    "5d6a6e8f8fe65ec7f7e0b132b75d85d3b918ec850f9f9b8d0f5742ab6d37f552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3aaa7755893eb4a178332afd8e340209f533bb54cd164701e7e3abcc9726f033"
  end

  depends_on "juju"
  depends_on "libyaml"
  depends_on "python@3.9"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
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
