class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "fcfdfa4224e2186a1672abd19bbeaa34d72df336df0cb83e8c5934c2de8ec8a8"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7845744525ceed9ee9987f1c5ed3fa25aabd5ce5388dbe9834c67b1393625d1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7845744525ceed9ee9987f1c5ed3fa25aabd5ce5388dbe9834c67b1393625d1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7845744525ceed9ee9987f1c5ed3fa25aabd5ce5388dbe9834c67b1393625d1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1d5edb8edb69c777e0167bdab69af915f04f1374aeb5c3b165514f85ef1ab2d"
    sha256 cellar: :any_skip_relocation, ventura:       "e1d5edb8edb69c777e0167bdab69af915f04f1374aeb5c3b165514f85ef1ab2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4fedf75ba18133f3e1f13830033f2934d507643e2b1d394cff04c366c6866fb"
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
