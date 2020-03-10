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
    sha256 "6bdcfe17d7687fad2e523e104b473744831806b1bf5915d9248a6d36dd6d28e6" => :catalina
    sha256 "ee281bb04fe93d458c63dba2648861dd30e2003f5bb8871e650959134c6daca7" => :mojave
    sha256 "72ec0aecb258232a837709d55ae03b4068db623c5f6b214bb2cbedd826c1152e" => :high_sierra
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
