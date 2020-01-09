class GitPlus < Formula
  include Language::Python::Virtualenv

  desc "Git utilities: git multi, git relation, git old-branches, git recent"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://files.pythonhosted.org/packages/72/75/5de42fceb6a7feb50386f29bd2a9d5391c90ba4e74ab78d86c095edd9f21/git-plus-v0.3.3.tar.gz"
  sha256 "54fa88f82e52863dcf5f2d44c258a22e8d31232473300a4384eba8e2f71df1ea"
  revision 1
  head "https://github.com/tkrajina/git-plus.git"

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir "testme" do
      system "git", "init"
      touch "README"
      system "git", "add", "README"
      system "git", "commit", "-m", "testing"
      rm "README"
    end

    assert_match "D README", shell_output("#{bin}/git-multi")
  end
end
