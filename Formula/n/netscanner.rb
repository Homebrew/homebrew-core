class Netscanner < Formula
  desc "Network scanner with features like WiFi scanning, packetdump and more"
  homepage "https://github.com/Chleba/netscanner"
  url "https://github.com/Chleba/netscanner/archive/refs/tags/v0.6.41.tar.gz"
  sha256 "1e913b7d9cde8953d2ea77307d91c55240bc94308ac9e321a8a843f930350e04"
  license "MIT"
  head "https://github.com/Chleba/netscanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bbdc73b8f4388e4eb8eda83524478f41432634a4af62e957cafff816da58241"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c6ef877e040dfdf0e498947e9cf128844e26e75588710ecf3a4aa30bd5bad24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9de8c346a2068284a49bad268959a331d9b8e6734ab3bc04357c68b957540bc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb838a3d0b5d954271195ef760920298825cf9daddba983bb5e00683de0f0761"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f63fc1a81c0d4abfa64065b4a6f93fa19de58f54af00a20fd95148e2fcbe650a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "885f563d930c6cffece877d5ddbb16170f83df76fea607e29ec302f65cc4bb83"
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
