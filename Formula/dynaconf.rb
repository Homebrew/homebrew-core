class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/2c/45/76c978c725b020be65a95b8b427e3550c76478a90e5396a33b0b204cae45/dynaconf-3.1.8.tar.gz"
  sha256 "d141a6664fca3648d2d8e84440966af9f58c4f4201ca78353a3f595a67c19ab4"
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
