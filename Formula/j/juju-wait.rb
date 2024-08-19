class JujuWait < Formula
  include Language::Python::Virtualenv

  desc "Juju plugin for waiting for deployments to settle"
  homepage "https://launchpad.net/juju-wait"
  url "https://files.pythonhosted.org/packages/0c/2b/f4bd0138f941e4ba321298663de3f1c8d9368b75671b17aa1b8d41a154dc/juju-wait-2.8.4.tar.gz"
  sha256 "9e84739056e371ab41ee59086313bf357684bc97aae8308716c8fe3f19df99be"
  license "GPL-3.0-only"
  revision 3

  bottle do
    rebuild 5
    sha256 cellar: :any,                 arm64_sonoma:   "586783238caaf8b1947e5f37955209eb7df05b528cddb3cccfa0e4f3ba01c7cc"
    sha256 cellar: :any,                 arm64_ventura:  "f2583a6872555a52166daae3ab7a6fe3d625f273b7f0b2fcd4d6657c48108350"
    sha256 cellar: :any,                 arm64_monterey: "06cf598be9fb449ffe7a666d2d2361b185fb47b1963353e0ef0906c8d07c24f8"
    sha256 cellar: :any,                 sonoma:         "efc417cd2f1b32f71a7cf94aefc45c8d962c6b43c4d31dceaf8e616fae81b303"
    sha256 cellar: :any,                 ventura:        "4c518cb63b8ee35f9ee3d68cbf31ab4c8969c5542fb7be107241e84d7fcdf2de"
    sha256 cellar: :any,                 monterey:       "910d64ff5fca96376a9faca8ec8e5f2ea2d5962c46fac12cc62fb0d3be4839e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "227cffc879030285ded0425b1d084c63acf69aa453841bde987666f0fb296798"
  end

  # From homepage:
  # [DEPRECATED] Since Juju 3, there's a native Juju command covering this -
  # https://juju.is/docs/olm/juju-wait-for. Please use that instead.
  deprecate! date: "2024-02-22", because: :deprecated_upstream

  depends_on "juju"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c9/3d/74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fad/setuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
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
