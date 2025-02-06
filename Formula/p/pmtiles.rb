class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "8fc03aeaf3b7eab3cc31cd3c03b811abbdbd4ed9bb5b6e5a5560e5a8526cdc14"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a7e1c26bfe93da951f3dc7b924b0b7275679233dc63c777107ec097b9aa20a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a7e1c26bfe93da951f3dc7b924b0b7275679233dc63c777107ec097b9aa20a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a7e1c26bfe93da951f3dc7b924b0b7275679233dc63c777107ec097b9aa20a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f10727d638e37c6d402a5f742182b88a7bbda245d927b8671171c4913f28d49"
    sha256 cellar: :any_skip_relocation, ventura:       "8f10727d638e37c6d402a5f742182b88a7bbda245d927b8671171c4913f28d49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a9167fba8118e4b453881d00a8f6b1c5c19eb1d9e7d721ddd9ab0379b789b1c"
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
