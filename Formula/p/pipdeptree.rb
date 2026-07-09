class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/ed/d5/3a51faf0d4834a91e0be60aa5a1c644c643b19f71fbcd66563415db6feaf/pipdeptree-3.1.1.tar.gz"
  sha256 "a986376399e52c9ec7515ef69df7a2dbda0bae0be1cec90dcae23a4ba6262c89"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "39124e25d29ba1454655322cd85d26ad97711a204d5f813cdb4160c3ddc11071"
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
