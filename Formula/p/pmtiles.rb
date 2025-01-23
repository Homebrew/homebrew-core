class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "fe4a63efe6cf8b3dbd36cb5e3afa57f518fa80f9b30629dbaffce8e8bd2b6015"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35d93ad49765762fa5faae6015c8790a70112cbaa7249f544f695d9fa1093328"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35d93ad49765762fa5faae6015c8790a70112cbaa7249f544f695d9fa1093328"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35d93ad49765762fa5faae6015c8790a70112cbaa7249f544f695d9fa1093328"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a7a88facca73560f3082b38ba18e971e19fc962826ceaecc3e9470f0dd43015"
    sha256 cellar: :any_skip_relocation, ventura:       "6a7a88facca73560f3082b38ba18e971e19fc962826ceaecc3e9470f0dd43015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d73bc1b024c48b7c047929886afdaad48dbdfff3773c12178ffd485e24eb214"
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
