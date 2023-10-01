class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "a551239ee7f4c4bf93b76bd57af24aae3d924c71e1b6be8faeddc13c9aed1116"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b44ed99f24218f5690bcdecba07491e5fddbb9967c13e83a27358c0f87145f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8689cf2bc209a39a7bc0de1a44aeea9b210b530208c78fca6838c2cc4aac47cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cdfec317a2431d506075f8486699cc359f3114966869c608e4df4d04be3cc9c9"
    sha256 cellar: :any_skip_relocation, ventura:        "49614668832632788a864cfc7a64620bde13fc27dbb50e7f097c3af084022433"
    sha256 cellar: :any_skip_relocation, monterey:       "14fd897a58fefae4cf1102c600eb4b01a1a4cea7eba458a083c52b1f35133016"
    sha256 cellar: :any_skip_relocation, big_sur:        "85de83ec6387f801141c526f910a1e932c8374565bc1293311f4e3d8d87f4b0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14fc200074ba8823e89b22df74ba1c434a413466fbf8cd7a39eed3c86bee2da7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    port = free_port

    pid = fork do
      exec "#{bin}/pmtiles", "serve", ".", "--port", port.to_s
    end
    sleep 3
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "404 Not Found", output
  ensure
    Process.kill("HUP", pid)
  end
end
