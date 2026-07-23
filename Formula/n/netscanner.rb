class Netscanner < Formula
  desc "Network scanner with features like WiFi scanning, packetdump and more"
  homepage "https://github.com/Chleba/netscanner"
  url "https://github.com/Chleba/netscanner/archive/refs/tags/v0.6.43.tar.gz"
  sha256 "6f16a5f2359035ec19652aac790eccf93f319b57aefe09693c9aa4f5dcdc1b62"
  license "MIT"
  head "https://github.com/Chleba/netscanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e47b59ffac58aac02957aecdaa003ecd8fde798c9ecc3e97f53c4f68373b863b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b291b0a5d49d813722d135e5ea4b6a65defba828db5330b902a3cc46ea6bf49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bae3c58abbafd36fa056a98c7d03c6ac58a80032d4a04acaae4cdeca87aca896"
    sha256 cellar: :any_skip_relocation, sonoma:        "c138e3321e37dc57718f3b795ddd910b91db445b8b8ae231f991f2b38cfb2af8"
    sha256 cellar: :any,                 arm64_linux:   "ddb5f26bfb2214de3a3621550624b8dc61e6a65e9b27987a210351d3aa3866db"
    sha256 cellar: :any,                 x86_64_linux:  "444654748a727502c4f0e76922bfbd9e9eb439fb351ff4a7e30327b71621fe70"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/netscanner --version")

    # Requires elevated privileges for network access
    assert_match "Unable to create datalink channel", if OS.mac?
      shell_output("#{bin}/netscanner 2>&1")
    else
      require "pty"
      r, _w, pid = PTY.spawn("#{bin}/netscanner 2>&1")
      r.winsize = [80, 43]
      Process.wait(pid)
      r.read_nonblock(1024)
    end
  end
end
