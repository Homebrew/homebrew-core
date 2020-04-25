class GitPlus < Formula
  include Language::Python::Virtualenv

  desc "Git utilities: git multi, git relation, git old-branches, git recent"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://files.pythonhosted.org/packages/89/ec/44fa075a08a3b9bede724a81361f89f7b4b4876540528d4a47a131153740/git-plus-v0.4.3.tar.gz"
  sha256 "1673a14ae311d6545b3901a771102afe576d48ed43320c416ed94b3ce613e7c1"
  head "https://github.com/tkrajina/git-plus.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4ef55a7a9983b50f263cadc7f11a18225ed7f1736bbeb1077aca7f4f3506362" => :catalina
    sha256 "c265fd83d70e9b889e14b43cc20cff89b996ce0f81b2a00e235025982914d509" => :mojave
    sha256 "b5d09be155b8d7bfa239d5030f4e0adfadf91c08d32e3f9900d89d2d0a813870" => :high_sierra
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
