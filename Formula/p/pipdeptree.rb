class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/03/65/f1881a1b6c49e9c94a463f7c52a23cbadcb0e778418056c9f97cbfae4ede/pipdeptree-2.30.0.tar.gz"
  sha256 "0f78fe4bcf36a72d0d006aee0f4e315146cb278e4c4d51621f370a3d6b8861c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b8028c2d21019cc215c8b586eb20b3e04fd44cfb380da1b6abc353acf5c10f90"
  end

  depends_on "python@3.14"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
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
