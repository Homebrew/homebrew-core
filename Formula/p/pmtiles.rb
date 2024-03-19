class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "f33cd53cc9307d7674d860cc6d91098efc5e8756fa4b86200729eee69f56081f"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "032d3da35cc06592a116e8eaf689d055778522a3357dd2e4a0d01dab70e4bf1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44b1b6206951ce3527f46c5ef6aabfe62af67cb1b3c83999046368ca635d3577"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b92e953c79bce1cd2394496297034efea3e5236b56dc8a8f8f857913da9a8d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "88e1b30a7fccf34cdd48f081490d319783c1f6674974f1e665cc743575346049"
    sha256 cellar: :any_skip_relocation, ventura:        "0c1af2f6fdc5c9b3468a29e22892a1915ce0143a3b903f2ce300cfe630b7fe52"
    sha256 cellar: :any_skip_relocation, monterey:       "62d7cfb6cc531032110e19bb81e2b21bc4c8fccc00e95e23fb3cc30f7c85fbbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ff65125a5de05367232b71a844f9a50dccb375841bf0d8bc9bcba32e21daf76"
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
    assert_match "HTTP/1.1 204 No Content", output
  ensure
    Process.kill("HUP", pid)
  end
end
