class AniCli < Formula
  desc "A cli tool to browse and play anime"
  homepage "https://github.com/pystardust/ani-cli/"
  sha256 "b53a8ebf7bf44bc7497ad4b4247e941ca9a7a89365717d3f4a2da349bcc80e45"
  url "https://github.com/pystardust/ani-cli/archive/refs/tags/v1.6.tar.gz"
  license "GPL-3.0"

  depends_on "grep"
  depends_on "curl"
  depends_on "openssl"
  depends_on "aria2"
  depends_on "mpv"
  
  def install
    bin.install 'ani-cli'
  end
end
