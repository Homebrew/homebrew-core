class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.27.1.tar.gz"
  sha256 "07908947ffa5ebe37af8140f4938ad1842f6d61dbccd612b357811013d7be7b1"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50d3ce3a7117151710050acb75811e1a2ac62855e2b945759abfd119d816931f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50d3ce3a7117151710050acb75811e1a2ac62855e2b945759abfd119d816931f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50d3ce3a7117151710050acb75811e1a2ac62855e2b945759abfd119d816931f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e0c0d2e33c7298829760458135200145dcb396129768fbfe7c6309dea401651"
    sha256 cellar: :any_skip_relocation, ventura:       "1e0c0d2e33c7298829760458135200145dcb396129768fbfe7c6309dea401651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "716d85f14670b2c638b2ed82d5e2575525f7af45d0e035eba6738f9a0b3ec06b"
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
