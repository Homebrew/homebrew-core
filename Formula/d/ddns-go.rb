class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.16.10.tar.gz"
  sha256 "0af625f11d396d3839486b5d985b58edf7e0712267da0e2a8e1a1f52cc7329ef"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14d50191642893a4b0620a43f398df8342cbc97ad81c7493698e012b66db3e65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14d50191642893a4b0620a43f398df8342cbc97ad81c7493698e012b66db3e65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14d50191642893a4b0620a43f398df8342cbc97ad81c7493698e012b66db3e65"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f5259f42450e7d816f3e00d9c7b31f5e31254c83a8f2dd21c7a9cb3f1ef2e5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f3034005cbd66ebfe7356d41be52a97f543c7d2de1dff9a69ed30a0d682033e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c4387af95c0c173faff6174708011bcd39907d9c5b80f28411d2129ff0cf2bb"
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
