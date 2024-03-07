class MuRepo < Formula
  include Language::Python::Virtualenv

  desc "Tool to work with multiple git repositories"
  homepage "https://github.com/fabioz/mu-repo"
  url "https://files.pythonhosted.org/packages/0d/3d/ddf28cf3beafadb5b3ea45ab882530c1d993b4fc10c0c61d82c8da624f3d/mu_repo-1.9.0.tar.gz"
  sha256 "f557e46e35a6dd8e1a8735c2a74ea1e60e9280040abc22a472e88eff0d23c5ca"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ecc6ced2f1ff8a4fc6d0412356142dc30b12250a456405be87ab3b13c0654fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f24b5dba19024ff297556f074cf0432c797148c1b6860bc316e7fdab3153679"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2746ab00ceb108999146b92cd79847dc6d4e1a0ca3a6124b775b0aa01b53b3b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "82560f8529b37534ab1fcef16e54c94973f09486761dbe6d860d3ea1ba0b9656"
    sha256 cellar: :any_skip_relocation, ventura:        "18a1d1ac055a963054206afebbeb815aa5e49b4ebbb83e6588af6da68bb2f4b3"
    sha256 cellar: :any_skip_relocation, monterey:       "9fe0abc3be0d941d5e28115fe22962a49e6549dfd38e96f005632bc80bfe2014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "588b88eb3c02c606173e18626c90ebe3d1f671f3e613afbeaf5f70753f4bd67b"
  end

  depends_on "python@3.12"

  conflicts_with "mu", because: "both install `mu` binaries"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_empty shell_output("#{bin}/mu group add test --empty")
    assert_match "* test", shell_output("#{bin}/mu group")
  end
end
