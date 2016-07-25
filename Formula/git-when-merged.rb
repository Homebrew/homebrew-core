class GitWhenMerged < Formula
  desc "Find where a commit was merged in git."
  homepage "https://github.com/mhagger/git-when-merged"
  url "https://github.com/mhagger/git-when-merged/archive/v1.1.0.tar.gz"
  sha256 "18a77eff1d5a477ab509f87610f69909b823c5d3b78fd7e556be5c7d6918087c"

  bottle :unneeded

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
