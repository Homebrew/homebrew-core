class GitFresh < Formula
  desc "Utility to keep git repos fresh"
  homepage "https://github.com/imsky/git-fresh"
  url "https://github.com/imsky/git-fresh/archive/v1.9.0.tar.gz"
  sha256 "f79a1c8fc45ddbc999404530f4f4df30f80276b02e86f5d9d13f971f7244b65b"

  bottle :unneeded

  def install
    system "./install.sh", bin
  end

  test do
    system "#{bin}/git-fresh", "-T"
  end
end
