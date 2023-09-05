class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/6d/b4/42f9f41df0a00084904778cd52b0d400ee34317f67b071f68df48dec62d5/pipdeptree-2.13.0.tar.gz"
  sha256 "ff71a48abd0b1ab810c23734b47de6ebd93270857d6665e21ed5ef6136fcba6e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e84f824be54564cc09fe56c7c198447a35ff85391de158d34432dff183dcd87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f7b325351b7153b7c8f88c92e4c5d470c8cc1a8f6393ca3b542e2d960627fce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d76afea856091e47b805b4bfda708a12a4d6aee16d66dd72db2b0609675bd265"
    sha256 cellar: :any_skip_relocation, ventura:        "7f1d9d978ef8069bb7923c1177e9a9855947b85ec619e662880c592b1b2dda59"
    sha256 cellar: :any_skip_relocation, monterey:       "0ed03fc8e8036c41b63ce1ef934c3e6c76fcfa56fe626597ecf5553b62762fe1"
    sha256 cellar: :any_skip_relocation, big_sur:        "c251ba421de9451114ea03bc807f4cbef4e9de066993d201cfe4ae2409b5adce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5259fa298e6a857f95b7bbdc331fe3485e39111b7d194196cce9a11b5f4cdee"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
