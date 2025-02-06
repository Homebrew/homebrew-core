class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/35/3c/cbb09611ee5e182083484a18418e43176cf91b25144215703fc54dbb19d4/dynaconf-3.2.7.tar.gz"
  sha256 "1246ef16b0577aa25876f1606e8eb2ea2d9acc61a39087e01c90c5a9da787b46"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "68b599b9950575e40cce970c3358a1b39204ec783bfda273e3a834a042d62271"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"dynaconf", "init"
    assert_predicate testpath/"settings.toml", :exist?
    assert_match "from dynaconf import Dynaconf", (testpath/"config.py").read
  end
end
