class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "c88e0905760a42c136f735df7c06893a9ad74f55c9c326101b175ca617cab4de"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1c7e925f84706b61851b159e9ba3778e0b8d0e725e1b496b19d1cd09acc09db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23652a6dba1c0fff3cb64a2516c74f5296d65c8c235cb35a40c127e88d5c81e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c5678e07e839e173833348f51a39b3dcbd1cdcb73f81bc00ece2377225aa343"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee691732e11daf44ea77e46ae5874d3dd6ebbef3229bcb38bd051e8e42a925cd"
    sha256 cellar: :any_skip_relocation, ventura:        "7710fc16eb0997fef453a85be3f7dc7da6671438e12a7cd2e9889451f685fcea"
    sha256 cellar: :any_skip_relocation, monterey:       "2516bb2d3bfaaaf7a20f00e4766315a2b47d40df19180b91b0b908025cd4ea5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bebd24b8bf0bf79c64c96634cfd6a88f5075ae722c88099a5e4da4c2328ee3a"
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
