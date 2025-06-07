class GitUrlSub < Formula
  desc "Recursively substitute remote URLs for multiple repos"
  homepage "https://gosuri.github.io/git-url-sub"
  url "https://github.com/gosuri/git-url-sub/archive/refs/tags/1.0.1.tar.gz"
  sha256 "6c943b55087e786e680d360cb9e085d8f1d7b9233c88e8f2e6a36f8e598a00a9"
  license "MIT"
  head "https://github.com/gosuri/git-url-sub.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "055dea89e85d2f7947a37817d5d25f502f40416d0e35ccede1bfeb7795891be0"
  end

  # Script runs `find . -type dir` which is incorrect input to `-type` but
  # macOS/BSD `find` ignores the extra characters while GNU `find` fails.
  # Also uses shell features that don't work with `dash`.
  depends_on :macos

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "git", "init"
    system "git", "remote", "add", "origin", "foo"
    system bin/"git-url-sub", "-c", "foo", "bar"
    assert_match(/origin\s+bar \(fetch\)/, shell_output("git remote -v"))
  end
end
