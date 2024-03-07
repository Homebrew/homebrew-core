class GitPlus < Formula
  include Language::Python::Virtualenv

  desc "Git utilities: git multi, git relation, git old-branches, git recent"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://files.pythonhosted.org/packages/79/27/765447b46d6fa578892b2bdd59be3f7f3c545d68ab65ba6d3d89994ec7fc/git-plus-0.4.10.tar.gz"
  sha256 "c1b12553d22050cc553af6521dd672623f81d835b08e0feb01da06865387f3b0"
  license "Apache-2.0"
  head "https://github.com/tkrajina/git-plus.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5fbd2519c6729a1e271d26cf2d56899c61cf50b3d978d19102e833c8e5b5182d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07f38510f43f66d1c6c3c9d00b77befe903a3dbb724ae1aeba6cb36885b5bdc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87ac870e4d47335beff937f6d82e9a666670310491108d1dfa4f3361b2f3fd4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "68941a7991b73d33d307c13af6fd10e29d68f571130574f4ce2be868ca33fee8"
    sha256 cellar: :any_skip_relocation, ventura:        "dfe60bbc480ffc40633261fd456e222310c51deeea484dfe30400bbe4cff2639"
    sha256 cellar: :any_skip_relocation, monterey:       "212d0b92ca6302e017d9748551691759fc74f22ca76d4d43ff7a504906d60280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17a5f2ac5dc285ccbf339bfa7149b0e0554474015dfd9478b3435dcbd2a2eda3"
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
