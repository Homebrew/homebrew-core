class ChiselTunnel < Formula
  desc "Fast TCP/UDP tunnel over HTTP"
  homepage "https://github.com/jpillora/chisel"
  url "https://github.com/jpillora/chisel/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "818e1a3470597119e687a6657edb373a449455757ca4351dc5f3a1a89bba1513"
  license "MIT"
  head "https://github.com/jpillora/chisel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b638b4ba292b0585336998be698480619bbcffed2eb44677e72818c6717f8868"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b638b4ba292b0585336998be698480619bbcffed2eb44677e72818c6717f8868"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b638b4ba292b0585336998be698480619bbcffed2eb44677e72818c6717f8868"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3e5be84bf2849ddbf931b4142f069382fbdf7c6d567d377ac23153fcedd1a8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7e97edd404a431b1228dce95381e116f68c600d06d47ee86d3f7de42738391d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e04c08eb9c095bee99af08292b4f6a9e730441c40d7f60365f6831e384ec1dcc"
  end

  depends_on "go" => :build

  conflicts_with "chisel", because: "both install `chisel` binaries"
  conflicts_with "foundry", because: "both install `chisel` binaries"

  def install
    ldflags = "-s -w -X github.com/jpillora/chisel/share.BuildVersion=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"chisel")
  end

  test do
    _, write = IO.pipe
    server_port = free_port

    server_pid = fork do
      exec "#{bin}/chisel server -p #{server_port}", out: write, err: write
    end

    sleep 2

    begin
      assert_match "Connected", shell_output("curl -v 127.0.0.1:#{server_port} 2>&1")
    ensure
      Process.kill("TERM", server_pid)
      Process.wait(server_pid)
    end
  end
end
