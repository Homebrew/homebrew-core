class JujuWait < Formula
  include Language::Python::Virtualenv

  desc "Juju plugin for waiting for deployments to settle"
  homepage "https://launchpad.net/juju-wait"
  url "https://files.pythonhosted.org/packages/0c/2b/f4bd0138f941e4ba321298663de3f1c8d9368b75671b17aa1b8d41a154dc/juju-wait-2.8.4.tar.gz"
  sha256 "9e84739056e371ab41ee59086313bf357684bc97aae8308716c8fe3f19df99be"
  license "GPL-3.0-only"
  revision 3

  bottle do
    rebuild 6
    sha256 cellar: :any,                 arm64_sequoia: "7d8a37c0c1be688c222abe9d980a5368887f18f7436de14e82f526fe4e023d66"
    sha256 cellar: :any,                 arm64_sonoma:  "00e147b7a8901e7434e87712e73a684261f4e04e52f1fd6223db7dc767adf59b"
    sha256 cellar: :any,                 arm64_ventura: "50c5aa7e7a321b875f71e65536c52f9a6df5863a2f7d83ce20094eb9bafb3679"
    sha256 cellar: :any,                 sonoma:        "56133b32e2f328bf3933a4391207659ee41e43dff840a516fa001a7c5022ce0d"
    sha256 cellar: :any,                 ventura:       "81e3a1f0207ec945ec9b9cf4411a83c17a70c343ebe5d99d01d2400919b697d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ec1653bfe939709f0ebe1cffb1bd16f84da710adc34e301ec028849f4c92fd1"
  end

  # From homepage:
  # [DEPRECATED] Since Juju 3, there's a native Juju command covering this -
  # https://juju.is/docs/olm/juju-wait-for. Please use that instead.
  deprecate! date: "2024-02-22", because: :deprecated_upstream
  disable! date: "2025-02-24", because: :deprecated_upstream

  depends_on "juju"
  depends_on "libyaml"
  depends_on "python@3.13"

  pypi_packages extra_packages: "setuptools"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # NOTE: Testing this plugin requires a Juju environment that's in the
    # process of deploying big software. This plugin relies on those application
    # statuses to determine if an environment is completely deployed or not.
    system bin/"juju-wait", "--version"
  end
end
