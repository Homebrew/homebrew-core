class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.16.4.tar.gz"
  sha256 "15622bad59e897d1cf7fb52e3977b89b0653c9b2389f9993143f416bae195d7a"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a36366c0689b17a6c51d0f0c0bfeeb108c3fdf7d4555adf7f1f97cdb227a94a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a36366c0689b17a6c51d0f0c0bfeeb108c3fdf7d4555adf7f1f97cdb227a94a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a36366c0689b17a6c51d0f0c0bfeeb108c3fdf7d4555adf7f1f97cdb227a94a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd8b91db37445bc41a9bcbc8d0c94958309d1aae52526edd20e8583324303b2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baea0fd38ba2d3fbd0f0106d9417561ad78c00d94f251e77521a0e006613d386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6210feb83e740d2932bb906dc9010978777af573411fcec1f2b71e0057a6971"
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
