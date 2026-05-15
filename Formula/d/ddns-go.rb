class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.17.0.tar.gz"
  sha256 "b1693abe90941d9d6eaf893e73bd05c1e122cd2fff5f69409987b524b12f2ad0"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4a1f1fc2636ecf0af8d4f0b04582119f176cfa93774e113a800c296cb248a7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4a1f1fc2636ecf0af8d4f0b04582119f176cfa93774e113a800c296cb248a7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4a1f1fc2636ecf0af8d4f0b04582119f176cfa93774e113a800c296cb248a7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4729826ab84efcbf43008d60b2db31010a79379df230692a369970e2460d53b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7a27c604df99921e81c4c8b3d58a1bcaea11c398b99ba5a57dc803fc04ee580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99fd3d843b8b43df3dcd2e573101b3d2d83756b31eb6004aa02a47962bd49302"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ddns-go -v")

    port = free_port
    spawn "#{bin}/ddns-go -l :#{port} -c #{testpath}/ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}/clearLog"
    output = shell_output("curl --silent localhost:#{port}/logs")
    assert_match "Temporary Redirect", output
  end
end
