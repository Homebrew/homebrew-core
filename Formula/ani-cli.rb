class AniCli < Formula
  desc "A cli tool to browse and play anime"
  homepage "https://github.com/pystardust/ani-cli/"
  sha256 "2d86805953732dd6b101367c1748f0892610de6f8ac397791226f589603538fb"
  url "https://github.com/pystardust/ani-cli/archive/refs/tags/v1.5.tar.gz"
  license "GPL-3.0"

  depends_on "grep"
  depends_on "curl"
  depends_on "openssl"
  depends_on "cask"
  depends_on "aria2"
  depends_on "mpv"
  
  def install
    bin.install 'ani-cli'
  end
end
