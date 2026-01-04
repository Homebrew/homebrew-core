class GitBranchCleaner < Formula
  desc "Delete merged git branches"
  homepage "https://github.com/sinansonmez/git-branch-cleaner"
  version "1.0.0"
  license "MIT"

  on_macos do
    if on_arm?
      url "https://github.com/sinansonmez/git-branch-cleaner/releases/download/v1.0.0/git-branch-cleaner_darwin_arm64.tar.gz"
      sha256 "46f8d2e3674ef3524e62e2e994ce77fc47c332bb491e1f984348f251d56f465b"
    else
      url "https://github.com/sinansonmez/git-branch-cleaner/releases/download/v1.0.0/git-branch-cleaner_darwin_amd64.tar.gz"
      sha256 "3145dc59cd04b584c9155df836a2c840f36a7fc0b474994e7e3e219e9fa5a2a9"
    end
  end

  on_linux do
    if on_arm?
      url "https://github.com/sinansonmez/git-branch-cleaner/releases/download/v1.0.0/git-branch-cleaner_linux_arm64.tar.gz"
      sha256 "bae39012bb88fa2482467494ad1ef2806c74d2c664e4a650e9daa331582afe10"
    else
      url "https://github.com/sinansonmez/git-branch-cleaner/releases/download/v1.0.0/git-branch-cleaner_linux_amd64.tar.gz"
      sha256 "450640f04466cdb3d8eb64b79bbb25b9acfd74c2245a30a44bf98f2d77663775"
    end
  end

  def install
    bin.install "git-branch-cleaner"
  end

  test do
    system "#{bin}/git-branch-cleaner", "-h"
  end
end