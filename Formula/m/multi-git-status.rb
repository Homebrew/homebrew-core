class MultiGitStatus < Formula
  desc "Show uncommitted, untracked and unpushed changes for multiple Git repos"
  homepage "https://github.com/fboender/multi-git-status"
  url "https://github.com/fboender/multi-git-status/archive/refs/tags/2.3.tar.gz"
  sha256 "2634b4b8b3d69a397f5462ec1d72a77d5b395f363ed8e1aabfbf7e5e4172f93f"
  license "MIT"

  bottle do
    manifest_sha256 "8e85cfa3c7045a4c8e427633c70937c3143e5e9fcc4566d761fcb06de91df728"
    sha256 cellar: :any_skip_relocation, all: "011ea78413856d20a26c71c4cdcc1b7909ce6ab7075544c716359079eb4f3b06"
  end

  def install
    # This is what the included 'install.sh' script does, except that
    # we use Homebrew's preferred location for 'man1'.
    bin.install "mgitstatus"
    man1.install "mgitstatus.1"
  end

  test do
    mkdir "test-repo" do
      system "git", "init"
    end
    assert_match "./test-repo: Uncommitted changes", shell_output("#{bin}/mgitstatus 2>&1")
  end
end
