class GitFresh < Formula
  desc "Utility to keep git repos fresh"
  homepage "https://github.com/imsky/git-fresh"
  url "https://github.com/imsky/git-fresh/archive/v1.10.1.tar.gz"
  sha256 "7c90b6c918c51ef605f2faa60d0e15d804a29fc825965f78175be1aae423b415"

  bottle :unneeded

  def install
    system "./install.sh", bin
  end

  test do
    system "#{bin}/git-fresh", "-T"
  end
end
