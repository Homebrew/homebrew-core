class GitFresh < Formula
  desc "Utility to keep git repos fresh"
  homepage "https://github.com/imsky/git-fresh"
  url "https://github.com/imsky/git-fresh/archive/v1.11.0.tar.gz"
  sha256 "b8504e633c679b5112fc7ccfea354c4ceb01f9d6aa681abf09dc7c9564a7e38f"

  bottle :unneeded

  def install
    system "./install.sh", bin
  end

  test do
    system "#{bin}/git-fresh", "-T"
  end
end
