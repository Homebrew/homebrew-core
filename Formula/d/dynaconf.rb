class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/71/e4/723ba469856bb493c948985e5bd562c8a65f2b93e70c896e9764ab76de00/dynaconf-3.3.5.tar.gz"
  sha256 "a08f6ab44025034ef3c9f86b32548ab01efd4039094a74bd9f028a43c63d016f"
  license "MIT"
  head "https://github.com/dynaconf/dynaconf.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "7e6d4a4db8ee43d3dcc2676c417e28c4471360331117af6ba8f60e158848d3c0"
  end

  depends_on "python@3.15"

  def install
    # Backport 3.15 support: https://github.com/dynaconf/dynaconf/commit/455ee38569d76cd3707c73209b660cf60bd97b29
    inreplace "pyproject.toml", 'requires-python = ">=3.10,<3.15"', 'requires-python = ">=3.10"' if build.stable?
    virtualenv_install_with_resources
  end

  test do
    system bin/"dynaconf", "init"
    assert_path_exists testpath/"settings.toml"
    assert_match "from dynaconf import Dynaconf", (testpath/"config.py").read
  end
end
