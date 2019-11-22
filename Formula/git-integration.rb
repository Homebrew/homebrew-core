class GitIntegration < Formula
  desc "Manage git integration branches"
  homepage "https://johnkeeping.github.io/git-integration/"
  url "https://github.com/johnkeeping/git-integration/archive/v0.4.tar.gz"
  sha256 "b0259e90dca29c71f6afec4bfdea41fe9c08825e740ce18409cfdbd34289cc02"
  head "https://github.com/johnkeeping/git-integration.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fb8287c4f092454a224bcc948821610f64b790d14e8befe4db9f3d441e2caab3" => :catalina
    sha256 "96f0e7501667f2951628535f307efe672aa51daeb8af2509e0f04d06eb22b0e6" => :mojave
    sha256 "30757baa47338aaa0e43240237d1dfefc1b59e397b55f36d5b7176ca978d7698" => :high_sierra
    sha256 "30757baa47338aaa0e43240237d1dfefc1b59e397b55f36d5b7176ca978d7698" => :sierra
  end

  def install
    (buildpath/"config.mak").write "prefix = #{prefix}"
    system "make", "install"
    system "make", "install-completion"
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "An initial commit"
    system "git", "checkout", "-b", "branch-a", "master"
    system "git", "commit", "--allow-empty", "-m", "A commit on branch-a"
    system "git", "checkout", "-b", "branch-b", "master"
    system "git", "commit", "--allow-empty", "-m", "A commit on branch-b"
    system "git", "checkout", "master"
    system "git", "integration", "--create", "integration"
    system "git", "integration", "--add", "branch-a"
    system "git", "integration", "--add", "branch-b"
    system "git", "integration", "--rebuild"
  end
end
