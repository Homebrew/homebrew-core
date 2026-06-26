class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/5f/c8/6bf1aa9e219485189f92bf68def0ef46c7292ecf0399757c17754988fb4b/dynaconf-3.3.0.tar.gz"
  sha256 "923b8a497eda5457d88ec2f30389a564f7f5faaeb83399b027f0a6c50cf4516f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a9a33bd12af8a78eac4e1e74fb83ff32a7c28482c4c1dc17cf4db9e5f8fa10fb"
  end

  # TODO: switch to 3.14 when this PR is merged: https://github.com/dynaconf/dynaconf/pull/1398
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
