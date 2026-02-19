class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/cd/bd/7a6f84b68268fe1d12e709faec7d293e0c37c9c03bacaf363de41e7e7568/dynaconf-3.2.12.tar.gz"
  sha256 "29cea583b007d890e6031fa89c0ac489b631c73dbee83bcd5e6f97602c26354e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9680ab2704f9234471f5868430593e7883a33e1f218b8c1764339071938c6401"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"dynaconf", "init"
    assert_path_exists testpath/"settings.toml"
    assert_match "from dynaconf import Dynaconf", (testpath/"config.py").read
  end
end
