class GitUtils < Formula
  desc "Various Git helper utilities"
  homepage "https://github.com/ddollar/git-utils"
  url "https://github.com/ddollar/git-utils/archive/v1.0.tar.gz"
  sha256 "a65252222222981d769fe2b19508e698fac4a0ce72e4ff07e74851e99a8fc813"

  head "https://github.com/ddollar/git-utils.git"

  bottle :unneeded

  conflicts_with "git-extras",
    :because => "both install a `git-pull-request` script"

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
