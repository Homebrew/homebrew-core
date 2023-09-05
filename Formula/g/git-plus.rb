class GitPlus < Formula
  include Language::Python::Virtualenv

  desc "Git utilities: git multi, git relation, git old-branches, git recent"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://files.pythonhosted.org/packages/79/27/765447b46d6fa578892b2bdd59be3f7f3c545d68ab65ba6d3d89994ec7fc/git-plus-0.4.10.tar.gz"
  sha256 "c1b12553d22050cc553af6521dd672623f81d835b08e0feb01da06865387f3b0"
  license "Apache-2.0"
  head "https://github.com/tkrajina/git-plus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5993edd0f14bcf89323609395296369bf8c7c74697f421cf1324ed22246d295"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5993edd0f14bcf89323609395296369bf8c7c74697f421cf1324ed22246d295"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5993edd0f14bcf89323609395296369bf8c7c74697f421cf1324ed22246d295"
    sha256 cellar: :any_skip_relocation, ventura:        "9bdce13d800f40dc51edcb780600d7cf7775624173f54521e4b6544619adcd63"
    sha256 cellar: :any_skip_relocation, monterey:       "9bdce13d800f40dc51edcb780600d7cf7775624173f54521e4b6544619adcd63"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bdce13d800f40dc51edcb780600d7cf7775624173f54521e4b6544619adcd63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58dd04bb2b4161b60ace6be84dce6a355d093c4a0312a03010b7d39b20e7ab0d"
  end

  depends_on "python@3.11"

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
