class GitPlus < Formula
  include Language::Python::Virtualenv

  desc "Git utilities: git multi, git relation, git old-branches, git recent"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://files.pythonhosted.org/packages/b6/5b/1d659ada793200e2e16bf9fedffa9edabf98658eb09a38713f4b4a162f7a/git-plus-v0.4.4.tar.gz"
  sha256 "ff6e141d1a33c179a806f22bae2a7cf0fd69fcfcb70736294c579d6aeed67dbd"
  head "https://github.com/tkrajina/git-plus.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8004d2a502eaad6e616b140359d5a5af426dd767dad54477672b6f6ca8993b4f" => :catalina
    sha256 "8d35fc4e02f5587e140428e5546d36d76f33c3e4c13210b4e4257ecf723cf6ad" => :mojave
    sha256 "3b9f87989868d3042e0d62fe091c0c8529f34eeeefd73a6f58ffe2c9e233c36a" => :high_sierra
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
