class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.27.2.tar.gz"
  sha256 "896f0d55a0c1fbd3dde90e2a457e14d3603ed6782e894d42ff801a7527c043d8"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc78174e706c83e521fb71ad34a66cf0787b359c5f900f224d15ed870cfc44d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc78174e706c83e521fb71ad34a66cf0787b359c5f900f224d15ed870cfc44d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc78174e706c83e521fb71ad34a66cf0787b359c5f900f224d15ed870cfc44d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a5a69e2bf3f89a912111dcd4d3c1a572975216ccb8219a432296113516442c4"
    sha256 cellar: :any_skip_relocation, ventura:       "8a5a69e2bf3f89a912111dcd4d3c1a572975216ccb8219a432296113516442c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e5b82d1822771d84242e0bf15a03b8ff3655de61a80c0d1c02fd1d2c326675d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
