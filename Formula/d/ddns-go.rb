class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.12.4.tar.gz"
  sha256 "04f65f7f1ccc18b23dd108f915810146e8b655cd19e7d8ee488cf557222c3fee"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "908491cb80e6b606930f3f880e3e0b90c3d65dff0826d807a3e1974986d3802e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a00e7e8227f57f1a25677cd41e6b641b31b824d7b2762f0feb715c42290519e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a00e7e8227f57f1a25677cd41e6b641b31b824d7b2762f0feb715c42290519e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a00e7e8227f57f1a25677cd41e6b641b31b824d7b2762f0feb715c42290519e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6acbbf135f068361c4cb8c88e03a5285f839d0f79b0db44ad3d1f3f0ba7b3df7"
    sha256 cellar: :any_skip_relocation, ventura:       "6acbbf135f068361c4cb8c88e03a5285f839d0f79b0db44ad3d1f3f0ba7b3df7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3a4293f88ba0963bff5ab6d513311ba6de0d0b58c9957762dafb415f4d5d263"
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
