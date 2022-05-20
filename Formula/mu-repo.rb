class MuRepo < Formula
  include Language::Python::Virtualenv

  desc "Tool to work with multiple git repositories"
  homepage "https://github.com/fabioz/mu-repo"
  url "https://files.pythonhosted.org/packages/05/6b/27768e4cc1464a2b7c6b683c096edbdf38b8b994670e42814519ff067853/mu_repo-1.8.1.tar.gz"
  sha256 "1eb67031ff9d697adce375b122e0a76beb675c5ee6dfcabc848e78bdcfb4ed3d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bfa8b88548cb8bde371ba82d961023fb6380097fc0f9725738a3e8ef9e2c5ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bfa8b88548cb8bde371ba82d961023fb6380097fc0f9725738a3e8ef9e2c5ca"
    sha256 cellar: :any_skip_relocation, monterey:       "f22765952278d1299a518c8c9835a613045c46e5da7a68f746764402b265f590"
    sha256 cellar: :any_skip_relocation, big_sur:        "f22765952278d1299a518c8c9835a613045c46e5da7a68f746764402b265f590"
    sha256 cellar: :any_skip_relocation, catalina:       "f22765952278d1299a518c8c9835a613045c46e5da7a68f746764402b265f590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "753d0bded50ce2ea748a30779ff838e56dd6436a85d3f608386f3517c04568b4"
  end

  depends_on "python@3.10"

  conflicts_with "mu", because: "both install `mu` binaries"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_empty shell_output("#{bin}/mu group add test --empty")
    assert_match "* test", shell_output("#{bin}/mu group")
  end
end
