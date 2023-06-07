class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/63/38/ed036e126de2b477ba30ad6f91932e6271ce78c1aa34181b833ee60a3b24/dynaconf-3.1.12.tar.gz"
  sha256 "11a60bcd735f82b8a47b288f99e4ffbbd08c6c130a7be93c5d03e93fc260a5e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75be4380947cd5ce07a8eb88998f3137e14a1c0c7be0ac66b50ac313f06cfb01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75be4380947cd5ce07a8eb88998f3137e14a1c0c7be0ac66b50ac313f06cfb01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75be4380947cd5ce07a8eb88998f3137e14a1c0c7be0ac66b50ac313f06cfb01"
    sha256 cellar: :any_skip_relocation, ventura:        "5648d0c69387e98d1253f88dc292a8402142167f1f47ba01556cb882aece135c"
    sha256 cellar: :any_skip_relocation, monterey:       "5648d0c69387e98d1253f88dc292a8402142167f1f47ba01556cb882aece135c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5648d0c69387e98d1253f88dc292a8402142167f1f47ba01556cb882aece135c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f2ea6b10ca6579d88818a1789c35bb0839eefc4cda58da4ff93ace22d41339c"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"dynaconf", "init"
    assert_predicate testpath/"settings.toml", :exist?
    assert_match "from dynaconf import Dynaconf", (testpath/"config.py").read
  end
end
