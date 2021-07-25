class GitPlus < Formula
  include Language::Python::Virtualenv

  desc "Git utilities: git multi, git relation, git old-branches, git recent"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://files.pythonhosted.org/packages/e5/01/f7ff2dc29fd5b8ffe1382c5e44d4be671ea00000cb216ad2b67b8e58a5b4/git-plus-v0.4.7.tar.gz"
  sha256 "22e0e118ed94bdc4413a763774e8cf8dfd167a1209b9ee831eac1835d4bb5302"
  license "Apache-2.0"
  head "https://github.com/tkrajina/git-plus.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e2a53a282b0e444cb0aca6173d8475b803b247b72462605574f28f62d2f7d9b9"
    sha256 cellar: :any_skip_relocation, big_sur:       "6fbeb0f79fb3149feec139360140b71dc8905336fe3e57979a5555542b14315d"
    sha256 cellar: :any_skip_relocation, catalina:      "77a2c33cfbcaa7eeebf0599197ef9865821df0a513c60f768586049c78795709"
    sha256 cellar: :any_skip_relocation, mojave:        "de4043e1cd948c93b60ba863ddc3ed42528e733263efb54f4e4c608cc6fcb148"
    sha256 cellar: :any_skip_relocation, high_sierra:   "774bf600193c1446a6097675f995ec808eada8f45d9b78f735121de23cd3d56c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "752799724068b6b93212af72aa940030eae3a6a894a0b81f3a5c251a09c48d95"
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
