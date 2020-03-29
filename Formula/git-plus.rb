class GitPlus < Formula
  include Language::Python::Virtualenv

  desc "Git utilities: git multi, git relation, git old-branches, git recent"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://files.pythonhosted.org/packages/72/75/5de42fceb6a7feb50386f29bd2a9d5391c90ba4e74ab78d86c095edd9f21/git-plus-v0.3.3.tar.gz"
  sha256 "54fa88f82e52863dcf5f2d44c258a22e8d31232473300a4384eba8e2f71df1ea"
  revision 2
  head "https://github.com/tkrajina/git-plus.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "468fa18f8d027cf6218c48d2ca2a593c70bea13a0138ef5a10c0e8f02ce673ff" => :catalina
    sha256 "603af1693567409c616a81e382176dc22ab9623404e78ca2b024668ca3a6e17e" => :mojave
    sha256 "fdf09b61e60b1e9b8bbd880f8ab39163c8caf07e545fb88adea90823b36eda3d" => :high_sierra
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
