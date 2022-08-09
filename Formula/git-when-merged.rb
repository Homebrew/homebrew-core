class GitWhenMerged < Formula
  include Language::Python::Shebang

  desc "Find where a commit was merged in git"
  homepage "https://github.com/mhagger/git-when-merged"
  url "https://github.com/mhagger/git-when-merged/archive/v1.2.1.tar.gz"
  sha256 "46ba5076981862ac2ad0fa0a94b9a5401ef6b5c5b0506c6e306b76e5798e1f58"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e17a93477d9712acb9acb0c77f18c646d3a25faa19e7f9875d1a31cb44560003"
  end

  depends_on "python@3.10"

  def install
    rewrite_shebang detected_python_shebang, "bin/git-when-merged"
    bin.install "bin/git-when-merged"
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@example.com"
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
