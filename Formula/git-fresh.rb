class GitFresh < Formula
  desc "Utility to keep git repos fresh"
  homepage "https://github.com/imsky/git-fresh"
  url "https://github.com/imsky/git-fresh/archive/v1.8.0.tar.gz"
  sha256 "d05513f189b49573bd3d13015371a6ee06d84aae43443e37b31b940366ebe84b"

  bottle :unneeded

  def install
    system "./install.sh", bin
  end

  test do
    system "git-fresh", "-T"
  end
end
