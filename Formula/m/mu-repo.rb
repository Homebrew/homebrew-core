class MuRepo < Formula
  include Language::Python::Virtualenv

  desc "Tool to work with multiple git repositories"
  homepage "https://github.com/fabioz/mu-repo"
  url "https://files.pythonhosted.org/packages/0d/3d/ddf28cf3beafadb5b3ea45ab882530c1d993b4fc10c0c61d82c8da624f3d/mu_repo-1.9.0.tar.gz"
  sha256 "f557e46e35a6dd8e1a8735c2a74ea1e60e9280040abc22a472e88eff0d23c5ca"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f0b6830f332704ebb1e93443ce89744b4dee1da86466bad429e058b57c5f5ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2fc6827e214839353355f7bb1bd0e299dc441cfb740f823a51225706020cb21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d0299f79f9cfe5b09a8f42f1895417b7df7e759da16f5bd8bd08ead24263c8b"
    sha256 cellar: :any_skip_relocation, sonoma:         "9fe1e06c13e2e2458429074c943bc532b0b779aa50824cc041882b56ebd1d2b1"
    sha256 cellar: :any_skip_relocation, ventura:        "b1e6d72356bb09dfb97434197ab27115732f18f2867ec81670d30260c5fa2f72"
    sha256 cellar: :any_skip_relocation, monterey:       "ed579d012be18de44d5586a5fac9bca71f036519f08b3269ea0b5aa540ba39a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c06644e358dba26e24c06d2aa07a41117c7becfc86ddefaed2f2df6120922a8d"
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
