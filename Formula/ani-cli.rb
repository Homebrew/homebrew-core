class AniCli < Formula
  desc "A cli tool to browse and play anime"
  homepage "https://github.com/pystardust/ani-cli/"
  url "https://github.com/pystardust/ani-cli/archive/refs/tags/v1.6.tar.gz"
  sha256 "b53a8ebf7bf44bc7497ad4b4247e941ca9a7a89365717d3f4a2da349bcc80e45"
  license "GPL-3.0"

  uses_from_macos "curl"
  depends_on "aria2"
  depends_on "grep"
  depends_on "mpv"
  depends_on "openssl@1.1"

  def install
    bin.install "ani-cli"
  end
  test do
    output = pipe_output("#{bin}/ani-cli")
    assert_match "", output
    end
end
