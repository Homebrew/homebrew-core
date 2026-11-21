class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.18.0.tar.gz"
  sha256 "9bb699819cd40ec17dae986ae58b2c87bc18c678786c3b2d20bcdc8a8917eac0"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    manifest_sha256 "d6aef19fad8366b3f924fda1705a77e80a6385b48459289d58e7da1bbb5789e1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "893885618cfc374da6a299bb430201d5864e111e54f7416529683ef405c7444c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "893885618cfc374da6a299bb430201d5864e111e54f7416529683ef405c7444c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "893885618cfc374da6a299bb430201d5864e111e54f7416529683ef405c7444c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fd77398dabe041871db308acac68b6364884896617fd06b6e3c1bf5389c41427"
    sha256 cellar: :any,                 x86_64_linux:      "529382026918083034e92f405d7937e7bd5fc3de83211a6efb89004047646cf3"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
