class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.30.3.tar.gz"
  sha256 "a2fe60652aee5dfb2805ea354be2277758283a8996ac17b5c4cbf43d9558e6c2"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6348751a06a1d57bf8ea168eb368b9ee049132e065d4fd6e401340ca8e95b13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ee8c7f3cfba58fe59ecb7fca25d6e93a213763da3ad35a47d33448fd58f2c07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec21528e4f1e5564e2c7125f499a8043b68437523eb340558984a1b5dcf691fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf7e0e6299ce1279ee9864ba53abdcb78a86ec54e0a4ed876977cde4538d52dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a9f75fb3840177a4e0c96d2d30c4e9fd420e0a4af353336bed33f34bb2f31bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88e9575415e2625c0c41c35c1fbaddcd4d3eb806d71093021e3979ed79366309"
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
