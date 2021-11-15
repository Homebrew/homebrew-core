class GitIntegration < Formula
  desc "Manage git integration branches"
  homepage "https://johnkeeping.github.io/git-integration/"
  url "https://github.com/johnkeeping/git-integration/archive/v0.4.tar.gz"
  sha256 "b0259e90dca29c71f6afec4bfdea41fe9c08825e740ce18409cfdbd34289cc02"
  license "GPL-2.0"
  head "https://github.com/johnkeeping/git-integration.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c9a9061562b7dc26dd939fc1b87c73de47ada2b464831c34487aee34de3a4d0e"
    sha256 cellar: :any_skip_relocation, big_sur:       "404013683ac61ff782e7844fa971ba3a872d9462c64b82140bcc53fb7eaffad5"
    sha256 cellar: :any_skip_relocation, catalina:      "fb8287c4f092454a224bcc948821610f64b790d14e8befe4db9f3d441e2caab3"
    sha256 cellar: :any_skip_relocation, mojave:        "96f0e7501667f2951628535f307efe672aa51daeb8af2509e0f04d06eb22b0e6"
    sha256 cellar: :any_skip_relocation, high_sierra:   "30757baa47338aaa0e43240237d1dfefc1b59e397b55f36d5b7176ca978d7698"
    sha256 cellar: :any_skip_relocation, sierra:        "30757baa47338aaa0e43240237d1dfefc1b59e397b55f36d5b7176ca978d7698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07b5ebb8403f9d421dccb3a4ab447d8f4b4f233282d9a5446434007104ec20e1"
    sha256 cellar: :any_skip_relocation, all:           "07b5ebb8403f9d421dccb3a4ab447d8f4b4f233282d9a5446434007104ec20e1"
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
