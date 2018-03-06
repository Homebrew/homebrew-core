class GitSizer < Formula
  desc "Compute various size metrics for a Git repository"
  homepage "https://github.com/github/git-sizer"
  url "https://github.com/github/git-sizer/releases/download/v1.0.0/git-sizer-1.0.0-darwin-amd64.zip"
  sha256 "f3a1dec9bc2fdcdabef23bfa9213272102a1c3873ef644d7d741289f6bc10ef3"

  bottle :unneeded

  def install
    bin.install "git-sizer"
  end

  test do
    system "#{bin}/git-sizer"
  end
end
