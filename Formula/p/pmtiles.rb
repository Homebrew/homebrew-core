class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "b610603764ad7b8554e7c3e86232c38a73a4012ce61e2523c233445f51516138"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "723d252f82a2442577c6028c57377a563ecc2a33af5d419e05c936cbf4bb3f9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6736fb58f52ed6c3c4e154920a55f994e70701dabb0cf867b364788481883cfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d214969b8a3612dadc1b80dff3facd5654129faf9ac8fdd4e4e182a7ebd63aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea816ea8efe04a6b8521a747eccbbe41d82fbebd0e9d28505f0c4e2289e7a064"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fe462feb31732d8aa357ca5906e2250f6e52f607052de78374e3181a662183d"
    sha256 cellar: :any,                 x86_64_linux:  "46371756674b49a2910bc6f631d6c6063399249f247615f838dc9ba4f7ed8c59"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port = free_port
    pid = spawn bin/"pmtiles", "serve", ".", "--port", port.to_s
    sleep 3
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "HTTP/1.1 204 No Content", output
  ensure
    Process.kill("HUP", pid)
  end
end
