class GitPlus < Formula
  include Language::Python::Virtualenv

  desc "Git utilities: git multi, git relation, git old-branches, git recent"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://files.pythonhosted.org/packages/79/27/765447b46d6fa578892b2bdd59be3f7f3c545d68ab65ba6d3d89994ec7fc/git-plus-0.4.10.tar.gz"
  sha256 "c1b12553d22050cc553af6521dd672623f81d835b08e0feb01da06865387f3b0"
  license "Apache-2.0"
  head "https://github.com/tkrajina/git-plus.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5bb4f2e14194b3e79593c25fec859b7a7bf1284b65e10f4d9162c958a55ad377"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6df2c299ba55967cbd4437ea98a1b6c310939809029df4b41a855f8158d25152"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9fc5c6149789e187184b263f96f4c371f7f13eb2c522f47851260fb26103a64"
    sha256 cellar: :any_skip_relocation, sonoma:         "36c44924038cac6efbe7a5a4f81c517169ae1156974083b0f02efd2bfec62b31"
    sha256 cellar: :any_skip_relocation, ventura:        "0c47a36d4554ba4b180385e98aacb15093245e69c47d780e89a19789cb5b0f25"
    sha256 cellar: :any_skip_relocation, monterey:       "8bb9034816710fed89575a3166a11b00affc551ee3fd1c571f529a898a6fce45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f54d550604b3ffadd002cc9b65385c1fc42ea8dc40b5826ffebdb0a730504570"
  end

  depends_on "python@3.12"

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
