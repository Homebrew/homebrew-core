class MuRepo < Formula
  include Language::Python::Virtualenv

  desc "Tool to work with multiple git repositories"
  homepage "https://github.com/fabioz/mu-repo"
  url "https://files.pythonhosted.org/packages/0d/3d/ddf28cf3beafadb5b3ea45ab882530c1d993b4fc10c0c61d82c8da624f3d/mu_repo-1.9.0.tar.gz"
  sha256 "f557e46e35a6dd8e1a8735c2a74ea1e60e9280040abc22a472e88eff0d23c5ca"
  license "GPL-3.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "c1a12185e6ce3889731ba486e3fe58b862edcb5123e3877166b361aa7f3132ca"
  end

  depends_on "python@3.13"

  conflicts_with "mu", because: "both install `mu` binaries"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_empty shell_output("#{bin}/mu group add test --empty")
    assert_match "* test", shell_output("#{bin}/mu group")
  end
end
