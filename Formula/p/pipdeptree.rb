class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/47/fd/48835ffa0d70b8a861cf8986771dfdfc3245e9886e50e951a7500cad64db/pipdeptree-2.26.0.tar.gz"
  sha256 "9b8f3de54e87509a7e021d30bd39a1a6a1a45dce1489b8e785f2e90da06c3858"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7474ec1ccbafd4ea823211e76c4763e16d61bd6c2a71d9defeffa8809f4f578a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7474ec1ccbafd4ea823211e76c4763e16d61bd6c2a71d9defeffa8809f4f578a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7474ec1ccbafd4ea823211e76c4763e16d61bd6c2a71d9defeffa8809f4f578a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ffaf0dce132efa2a483e9713cd97032fff08c32cf977e8a5839ce36965aafa1"
    sha256 cellar: :any_skip_relocation, ventura:       "4ffaf0dce132efa2a483e9713cd97032fff08c32cf977e8a5839ce36965aafa1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7474ec1ccbafd4ea823211e76c4763e16d61bd6c2a71d9defeffa8809f4f578a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7474ec1ccbafd4ea823211e76c4763e16d61bd6c2a71d9defeffa8809f4f578a"
  end

  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
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
