class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.30.2.tar.gz"
  sha256 "709abc76640b2e40c121cafa4c42b1c4720349172b782ca3566b899f172eff0f"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "350a039911e8fb1516d1af68a5e124176f4c6db75a0fcccc54a3792fec409308"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "812b3609b9a49da95fc13d4db1097bc9b08483d85fd35a56991a5efa910c1696"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac143421c13632e067214f86bd057d83139b7c4448209aca0560d63cf1c48829"
    sha256 cellar: :any_skip_relocation, sonoma:        "95ba84435127974f308aafb87085d46463ebe29a3fd2f25b362fca8f4d63fcc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc8b8ae5e57299058b35799b65f362f0353f1acf0bd577a4dcfe697dc6b574d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c8b7e05b7235b28ae0aa56533b018b3d77e91b97dc38270151ad03e159fe902"
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
