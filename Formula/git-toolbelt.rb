class GitToolbelt < Formula
  desc "Suite of useful Git commands"
  homepage "https://github.com/nvie/git-toolbelt#readme"
  url "https://github.com/nvie/git-toolbelt/archive/v1.0.0.tar.gz"
  sha256 "039fbd0f6529d6d4d29eac4629d6b1a4d0a94440ec9a3121260c3274d7094e8f"

  def install
    bin.install "git-active-branches"
    bin.install "git-assume"
    bin.install "git-cherry-pick-to"
    bin.install "git-cleanup"
    bin.install "git-commit-to"
    bin.install "git-committer-info"
    bin.install "git-conflicts"
    bin.install "git-contains"
    bin.install "git-current-branch"
    bin.install "git-delouse"
    bin.install "git-drop-local-changes"
    bin.install "git-fixup"
    bin.install "git-has-local-changes"
    bin.install "git-has-local-commits"
    bin.install "git-initial-commit"
    bin.install "git-is-ancestor"
    bin.install "git-is-clean"
    bin.install "git-is-dirty"
    bin.install "git-is-headless"
    bin.install "git-is-repo"
    bin.install "git-local-branch-exists"
    bin.install "git-local-branches"
    bin.install "git-local-commits"
    bin.install "git-merge-status"
    bin.install "git-merged"
    bin.install "git-merges-cleanly"
    bin.install "git-modified"
    bin.install "git-push-current"
    bin.install "git-recent-branches"
    bin.install "git-remote-branch-exists"
    bin.install "git-remote-branches"
    bin.install "git-repo"
    bin.install "git-root"
    bin.install "git-sha"
    bin.install "git-show-assumed"
    bin.install "git-stage-all"
    bin.install "git-stash-everything"
    bin.install "git-tag-exists"
    bin.install "git-trash"
    bin.install "git-unassume"
    bin.install "git-undo-commit"
    bin.install "git-undo-merge"
    bin.install "git-unmerged"
    bin.install "git-unstage-all"
    bin.install "git-update-all"
    bin.install "git-workon"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test git-toolbelt`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
