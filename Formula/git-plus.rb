class GitPlus < Formula
  include Language::Python::Virtualenv

  desc "Git utilities: git multi, git relation, git old-branches, git recent"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://files.pythonhosted.org/packages/af/bd/0a60e89ff992a52ae519e1b849256f964dd75f00f12061c185ff177afe44/git-plus-v0.4.0.tar.gz"
  sha256 "12b048f0d0e3bc6af3ac2acd04cfd11f56f1a67d6c13a93fc4caa176102364c5"
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
