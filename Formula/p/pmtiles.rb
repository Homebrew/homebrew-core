class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.29.1.tar.gz"
  sha256 "f5435219bc04a3b835d1b5f80e170e9a7259fef1efd819ef0951000306cd29ab"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e51450bf08bcb6682cf27b35bef9ef0c55f9a877fa4fa9c29007c213c5b65aeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40a1c90d9e2f132e8a6b37d587e8b2437809e4939989c8ab4b39ac74bf1e7198"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62cde869d0feee3006bb1a68cc5d5ccbcdb3d32019ef4834c7c296525820a571"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a7e8fc3ac2446483dc14ff3794241a071e42306e66956bb6836f74b60e654c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac6ef2e2563377f5e016cca11c5e11e3c046f1a806ad75260ad55700d5737f04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46c67c14acef7d5f23939027182dac385145c176d22fff029eb698e188929ea7"
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
