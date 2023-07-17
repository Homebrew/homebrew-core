class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/e3/b5/ed56647826df29dba3cd946120e74060db63c9777d876e27d72ea8db4a8f/pipdeptree-2.10.1.tar.gz"
  sha256 "ecf9c7a72dc45d9854b0d9925bac8028f9599bb2900cf5687e48fb79e19954fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66cee59fddff527f7de4a7658e632a491978df41dfc1cc6e5152b712becc8588"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "865da117fbe1d63e11e8545bf99d5e3ca60562d500ae7932cdf72ac92a64be99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6971fa0acde1029429f9fcbcdd94cc7e9824d9a07322158538641e5fd37793f1"
    sha256 cellar: :any_skip_relocation, ventura:        "674b5a029caff02ceabf07fbda8efb1112b161a75e301674da7e300a34704442"
    sha256 cellar: :any_skip_relocation, monterey:       "ac86eba32f6cd9783b58d88e680972a5cf66ad5f00250a899552957b44a2366c"
    sha256 cellar: :any_skip_relocation, big_sur:        "474e775d3daaed6e7d36351b89476a5259fee51a2d4dd7156ce05a898bac81ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfc38b2dd8fa29b6595319a192e340630cd364d330b6a9c7bd82ee8bf42e0327"
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
