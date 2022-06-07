class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/f0/0e/3c102db167de3e2bb3a36a680a89c27b9b08d9f856b2164cc1a03db96f1c/dynaconf-3.1.9.tar.gz"
  sha256 "f435c9e5b0b4b1dddf5e17e60a1e4c91ae0e6275aa51522456e671a7be3380eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2bbb63ac41bf42f6ed9779029f5da69751b323c39b04ecb0523f583d303a6c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2bbb63ac41bf42f6ed9779029f5da69751b323c39b04ecb0523f583d303a6c1"
    sha256 cellar: :any_skip_relocation, monterey:       "a55a36bc394a5bc1833e859f27bf11c0dd3034a41249e63f793d14d8f53fcd7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a55a36bc394a5bc1833e859f27bf11c0dd3034a41249e63f793d14d8f53fcd7d"
    sha256 cellar: :any_skip_relocation, catalina:       "a55a36bc394a5bc1833e859f27bf11c0dd3034a41249e63f793d14d8f53fcd7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a91a7b187dcc010a3857ca276e34d3733bf2e5210a851d1c36c67566bb537309"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"dynaconf", "init"
    assert_predicate testpath/"settings.toml", :exist?
    assert_match "from dynaconf import Dynaconf", (testpath/"config.py").read
  end
end
