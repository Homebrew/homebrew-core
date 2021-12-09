class GitUtils < Formula
  desc "Various Git helper utilities"
  homepage "https://github.com/ddollar/git-utils"
  url "https://github.com/ddollar/git-utils/archive/v1.0.tar.gz"
  sha256 "a65252222222981d769fe2b19508e698fac4a0ce72e4ff07e74851e99a8fc813"
  head "https://github.com/ddollar/git-utils.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7c7e5940ae9e46d0dfacb6b2b8db5dcf98626012d57d563a9ec1ca852bf9f0fb"
  end

  disable! date: "2021-12-07", because: :no_license

  conflicts_with "git-extras",
    because: "both install a `git-pull-request` script"
  conflicts_with "willgit",
    because: "both install a `git-rank-contributors` script"

  def install
    bin.install Dir["git-*"]
  end

  test do
    touch "#{testpath}/somefile"
    system "git", "init"
    system "git", "wip"
    assert_match "wip", shell_output("git last 1")
  end
end
