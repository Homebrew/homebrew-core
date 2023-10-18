class JujuWait < Formula
  include Language::Python::Virtualenv

  desc "Juju plugin for waiting for deployments to settle"
  homepage "https://launchpad.net/juju-wait"
  url "https://files.pythonhosted.org/packages/0c/2b/f4bd0138f941e4ba321298663de3f1c8d9368b75671b17aa1b8d41a154dc/juju-wait-2.8.4.tar.gz"
  sha256 "9e84739056e371ab41ee59086313bf357684bc97aae8308716c8fe3f19df99be"
  license "GPL-3.0-only"
  revision 3

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b964072250fd4fc0930d02431037c75008e91338584ef64ebf3690e30fa40451"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93ef2e2bd11280c71d4ff71a189c6660888b1e1b57cf854e77e848fcb68ceb15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72670a66a3322b29fda3139ce923922a60e9a73f39e6fd8cb50b6ef326cf16b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "88c0b2f156a0d80c583da9f8694d937343ba0d332200f8f66fffa25ed52f8614"
    sha256 cellar: :any_skip_relocation, ventura:        "94143f3cdce9f58465abf05c338925950badeedd941a551e7babac27cd3b0a32"
    sha256 cellar: :any_skip_relocation, monterey:       "1dbc90f242ade37de5952256a392af87ccc1ac3d6c49001eb942fb76a36b3db3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "642a58a4256a48a36478e1ebc1df488b00a8375295986d21661ee34d702c34bb"
  end

  depends_on "juju"
  depends_on "python-setuptools"
  depends_on "python@3.12"
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
