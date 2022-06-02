class GitPlus < Formula
  include Language::Python::Virtualenv

  desc "Git utilities: git multi, git relation, git old-branches, git recent"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://files.pythonhosted.org/packages/b4/c8/11b61003533e8afc5e5730113c7b21f2268db87a46f37e2d910fb9bb7d76/git-plus-0.4.8.tar.gz"
  sha256 "4df7103a4a56cec52ca6b93cd1626b727ace76c9d6673a084a473fac84ae5ff8"
  license "Apache-2.0"
  head "https://github.com/tkrajina/git-plus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bc27d01ae10334384f7bfa583f7cf3558246738d95a15969d234a3744808c61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bc27d01ae10334384f7bfa583f7cf3558246738d95a15969d234a3744808c61"
    sha256 cellar: :any_skip_relocation, monterey:       "c27fdb895dfe71c44fa92aef98ccdf5d3c042e57873c9b6b98c79348199af34a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c27fdb895dfe71c44fa92aef98ccdf5d3c042e57873c9b6b98c79348199af34a"
    sha256 cellar: :any_skip_relocation, catalina:       "c27fdb895dfe71c44fa92aef98ccdf5d3c042e57873c9b6b98c79348199af34a"
    sha256 cellar: :any_skip_relocation, mojave:         "c27fdb895dfe71c44fa92aef98ccdf5d3c042e57873c9b6b98c79348199af34a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebe89d33926bdb53327c6712fac31d805a47778e103c2bfeeb532803a5f52a4c"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir "testme" do
      system "git", "init"
      system "git", "config", "user.email", "\"test@example.com\""
      system "git", "config", "user.name", "\"Test\""
      touch "README"
      system "git", "add", "README"
      system "git", "commit", "-m", "testing"
      rm "README"
    end

    assert_match "D README", shell_output("#{bin}/git-multi")
  end
end
