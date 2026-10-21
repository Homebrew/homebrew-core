class MuRepo < Formula
  include Language::Python::Virtualenv

  desc "Tool to work with multiple git repositories"
  homepage "https://github.com/fabioz/mu-repo"
  url "https://files.pythonhosted.org/packages/0d/3d/ddf28cf3beafadb5b3ea45ab882530c1d993b4fc10c0c61d82c8da624f3d/mu_repo-1.9.0.tar.gz"
  sha256 "f557e46e35a6dd8e1a8735c2a74ea1e60e9280040abc22a472e88eff0d23c5ca"
  license "GPL-3.0-only"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, all: "7e8bc07a6e1626120f16e38977d58dd0b9ebfc2ed7379b474e068165285d8c4e"
  end

  depends_on "python@3.15"

  conflicts_with "mu", because: "both install `mu` binaries"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_empty shell_output("#{bin}/mu group add test --empty")
    assert_match "* test", shell_output("#{bin}/mu group")
  end
end
