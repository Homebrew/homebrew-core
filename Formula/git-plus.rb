class GitPlus < Formula
  include Language::Python::Virtualenv

  desc "Git utilities: git multi, git relation, git old-branches, git recent"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://files.pythonhosted.org/packages/b6/5b/1d659ada793200e2e16bf9fedffa9edabf98658eb09a38713f4b4a162f7a/git-plus-v0.4.4.tar.gz"
  sha256 "ff6e141d1a33c179a806f22bae2a7cf0fd69fcfcb70736294c579d6aeed67dbd"
  head "https://github.com/tkrajina/git-plus.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0875303fc69f8abb59858ac8dacfa7ed077e6b61f3ebd65e4193734aeb0c3e95" => :catalina
    sha256 "36281a54494043f1ef9df79ce5297b5fd25cd4bc20d0d58b646429e31c1424ce" => :mojave
    sha256 "6dfe6ac0b463e2bad51c28634dcca9ea9756bfc2037f1ef36339e57bce9a6a53" => :high_sierra
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
