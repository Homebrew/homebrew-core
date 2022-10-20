class JujuWait < Formula
  include Language::Python::Virtualenv

  desc "Juju plugin for waiting for deployments to settle"
  homepage "https://launchpad.net/juju-wait"
  url "https://files.pythonhosted.org/packages/0c/2b/f4bd0138f941e4ba321298663de3f1c8d9368b75671b17aa1b8d41a154dc/juju-wait-2.8.4.tar.gz"
  sha256 "9e84739056e371ab41ee59086313bf357684bc97aae8308716c8fe3f19df99be"
  license "GPL-3.0-only"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb2b340dc557ca8966456d433cdcf924900610ec8c734a715b7376a3b39b8ce8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb2b340dc557ca8966456d433cdcf924900610ec8c734a715b7376a3b39b8ce8"
    sha256 cellar: :any_skip_relocation, monterey:       "01445d2f650d64e37127cbadc075d4d313836872731f451a869df6f518efbe51"
    sha256 cellar: :any_skip_relocation, big_sur:        "01445d2f650d64e37127cbadc075d4d313836872731f451a869df6f518efbe51"
    sha256 cellar: :any_skip_relocation, catalina:       "01445d2f650d64e37127cbadc075d4d313836872731f451a869df6f518efbe51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a21b460baa91aba883fc8ebbd8254443580143746d5859d81e8c425ef6d63b41"
  end

  depends_on "juju"
  depends_on "python@3.10"
  depends_on "pyyaml"

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
