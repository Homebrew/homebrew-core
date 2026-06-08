class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/46/77/6589d08fecd19365164e4c963177d8a8f70f0784fb22d9a2504a9e118d5c/pipdeptree-3.1.0.tar.gz"
  sha256 "52ecadd6e0dd95aaf61e83ed2810a9ba6af3154482583149d0e8bb0c1b6d7c46"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fa72d29d9ebace1136673afe6fb87f69cd4db67a9bcc79d3f0b21a11334a2c75"
  end

  depends_on "python@3.14"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
