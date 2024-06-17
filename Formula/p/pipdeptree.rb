class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/44/cc/6fd69029c44b353ff50c3e9b39194dcfa4cd9dedc5c6d5062deffa657e33/pipdeptree-2.22.0.tar.gz"
  sha256 "6e1728ee922d102b0ffbdcabf1388f0a44d69d221bb746083b815e3da9f47396"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59d630e30a35a286b795e1da4556f880f689349d60b02f405416a5f65f679d1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59d630e30a35a286b795e1da4556f880f689349d60b02f405416a5f65f679d1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59d630e30a35a286b795e1da4556f880f689349d60b02f405416a5f65f679d1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb742e40ab7e5ee4f35ee769de01ea9f280588a8c1c1733d8f8bf9fef4050ece"
    sha256 cellar: :any_skip_relocation, ventura:        "fb742e40ab7e5ee4f35ee769de01ea9f280588a8c1c1733d8f8bf9fef4050ece"
    sha256 cellar: :any_skip_relocation, monterey:       "fb742e40ab7e5ee4f35ee769de01ea9f280588a8c1c1733d8f8bf9fef4050ece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8114e99ecc8ea1e32f6cf16cc0ecef8c4cccb1b5f618872488a04794a553a0a"
  end

  depends_on "python@3.12"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
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
