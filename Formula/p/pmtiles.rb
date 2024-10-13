class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "bcb0b45afe51493e14aa5b5952d9298b9c4aa16a22f79ecd461357a60babc78c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b778f41b2dec07e831d779f3744370bfd1664df7a1953c9a9207c8bb788071b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b778f41b2dec07e831d779f3744370bfd1664df7a1953c9a9207c8bb788071b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b778f41b2dec07e831d779f3744370bfd1664df7a1953c9a9207c8bb788071b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bda855b49e9550098ff4a0c681d44f076d286d0c1e7bb0553dbeb6ae256da792"
    sha256 cellar: :any_skip_relocation, ventura:       "bda855b49e9550098ff4a0c681d44f076d286d0c1e7bb0553dbeb6ae256da792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d12b079a424d08834dc98177d53d1a0db734a314da828af250b626358da9f009"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    port = free_port

    pid = fork do
      exec bin/"pmtiles", "serve", ".", "--port", port.to_s
    end
    sleep 3
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "HTTP/1.1 204 No Content", output
  ensure
    Process.kill("HUP", pid)
  end
end
