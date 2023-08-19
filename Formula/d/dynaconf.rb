class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/c8/e8/96b5414be64d093f8140480e45084763583b1e8e188c3c562ca7c85d2f8e/dynaconf-3.2.1.tar.gz"
  sha256 "00dbd7541ca0f99bcb207cfc8aee0ac8f7d6b32bbb372e5b2865f0cb829b06c3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f64dd8835f2f05e16dfd81c57d729556a788c325e72a5d1ec36902687305bdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9fb6f9e65fc000294991cf251875a2648e47d0e83b54cec3e2d40a08c1e0aca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17c6fa557b8502fb331557bc901d69f3d5defa898901099286b1c05fb197e860"
    sha256 cellar: :any_skip_relocation, ventura:        "cc4b34cc1f4bbc8f01ac25e1c50d06af6c2d41e123f83df08962cd80d68296c9"
    sha256 cellar: :any_skip_relocation, monterey:       "caf3dc2ffd9f0831d18e4d19cd7d51c3ad36bc21f2d43263d23545cce1432436"
    sha256 cellar: :any_skip_relocation, big_sur:        "39428df242e87f7141bbf107fe21fdc9a38736aab64251bf5db4d15fb0bf854d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99ae714c1b754970255ccba9fd2c23b4d605ebeeebd3efd063b529896ba199cb"
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
