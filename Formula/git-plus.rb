class GitPlus < Formula
  include Language::Python::Virtualenv

  desc "Git utilities: git multi, git relation, git old-branches, git recent"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://files.pythonhosted.org/packages/73/b5/6cf7f0513fd1ef42b5a3ac0e342b3c4176551f60ad17fc5dbe52329f2b58/git-plus-v0.4.6.tar.gz"
  sha256 "bcf3a83a2730e8b6f5bc106db00b7b6be5df534cb9543ba7ecc506c535c5158b"
  license "Apache-2.0"
  head "https://github.com/tkrajina/git-plus.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "37e7a26aa4cca6a9b1fb8b2f87f84b4dac45c27a2393dd22100dd46a033cfc6c" => :catalina
    sha256 "7a324cb78e6055568c2d91f04172d5c7e0e4ef5fc1dcabcb8060773f78865873" => :mojave
    sha256 "8b2e2b84a5525f199a20dafc0e1d4726ce53352eeb9e21479741b2331910afac" => :high_sierra
  end

  depends_on "python@3.8"

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
