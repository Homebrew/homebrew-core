class GitPlus < Formula
  include Language::Python::Virtualenv

  desc "Git utilities: git multi, git relation, git old-branches, git recent"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://files.pythonhosted.org/packages/e5/01/f7ff2dc29fd5b8ffe1382c5e44d4be671ea00000cb216ad2b67b8e58a5b4/git-plus-v0.4.7.tar.gz"
  sha256 "22e0e118ed94bdc4413a763774e8cf8dfd167a1209b9ee831eac1835d4bb5302"
  license "Apache-2.0"
  head "https://github.com/tkrajina/git-plus.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "27ca4d78d0e0b9442d8aadbe70e62c46512036e20fea16794ebc7b155a4ba55b"
    sha256 cellar: :any_skip_relocation, big_sur:       "243b9a0bf17f0e8ae3abe57100618440aa785f5f087d214e45732b48bb998dc1"
    sha256 cellar: :any_skip_relocation, catalina:      "243b9a0bf17f0e8ae3abe57100618440aa785f5f087d214e45732b48bb998dc1"
    sha256 cellar: :any_skip_relocation, mojave:        "243b9a0bf17f0e8ae3abe57100618440aa785f5f087d214e45732b48bb998dc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a07a67c06fac3c4de1c84960b38dda0bd3b06476c48e12eaddf0a03f25f7e214"
  end

  depends_on "python@3.9"

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
