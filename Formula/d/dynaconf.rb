class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/98/a8/bd76f872481c783a7e29cf0d4eccf773b1a2418b971f389245964223dcd6/dynaconf-3.2.10.tar.gz"
  sha256 "8dbeef31a2343c8342c9b679772c3d005b4801c587cf2f525f98f57ec2f607f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d16d121cb8ee8c6f5db0f745e28413a935e997df9f8b5cbe9c317101cef64183"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"dynaconf", "init"
    assert_path_exists testpath/"settings.toml"
    assert_match "from dynaconf import Dynaconf", (testpath/"config.py").read
  end
end
