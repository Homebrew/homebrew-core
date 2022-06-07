class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/f0/0e/3c102db167de3e2bb3a36a680a89c27b9b08d9f856b2164cc1a03db96f1c/dynaconf-3.1.9.tar.gz"
  sha256 "f435c9e5b0b4b1dddf5e17e60a1e4c91ae0e6275aa51522456e671a7be3380eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3db109fc4f9c1731d43647a2c421e7d1cc879b5703abcb257a42b74b3568d30e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3db109fc4f9c1731d43647a2c421e7d1cc879b5703abcb257a42b74b3568d30e"
    sha256 cellar: :any_skip_relocation, monterey:       "46a93b62b260d0805e30abe427ba5893af6ee2e40e5a035502f39d880a546d3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "46a93b62b260d0805e30abe427ba5893af6ee2e40e5a035502f39d880a546d3b"
    sha256 cellar: :any_skip_relocation, catalina:       "46a93b62b260d0805e30abe427ba5893af6ee2e40e5a035502f39d880a546d3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a11204edb0ae3ca2eb0aae97e266f6e0884732380e01fe5a4cafa3b10a94dc72"
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
