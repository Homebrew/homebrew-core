class GitWhenMerged < Formula
  desc "Find where a commit was merged in git"
  homepage "https://github.com/mhagger/git-when-merged"
  url "https://github.com/mhagger/git-when-merged/archive/v1.2.0.tar.gz"
  sha256 "3fb3ee2f186103c2dae1e4a2e104bc37199641f4ffdb38d85ca612cf16636982"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "67a1db2415c0aa7026ad1958a6966b909575ded3f7c5c63297aff72ca8eb76b0"
  end

  def install
    bin.install "bin/git-when-merged"
  end

  test do
    system "git", "init"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "foo"
    system "git", "checkout", "-b", "bar"
    touch "bar"
    system "git", "add", "bar"
    system "git", "commit", "-m", "bar"
    system "git", "checkout", "master"
    system "git", "merge", "--no-ff", "bar"
    touch "baz"
    system "git", "add", "baz"
    system "git", "commit", "-m", "baz"
    system "#{bin}/git-when-merged", "bar"
  end
end
