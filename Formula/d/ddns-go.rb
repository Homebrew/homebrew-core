class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.15.0.tar.gz"
  sha256 "f4443c44c7247fee49bfbd8e06b7c03b2f59cb99968e685b5655017cbd8dabf8"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c45e9ebe59496971e513fca7599a45c2e70e3d6d2fe38f7d85ae9bdfe98ad7d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c45e9ebe59496971e513fca7599a45c2e70e3d6d2fe38f7d85ae9bdfe98ad7d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c45e9ebe59496971e513fca7599a45c2e70e3d6d2fe38f7d85ae9bdfe98ad7d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d7f1d5f8c6b430062170e1d91252a85e03bfd97a6790568d95e7f220fed9194"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7148a47ac865a65eb1dbea0ab3cad735374f7536663fb9d30a8bb116a2fd01eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c829999be69ff3b5ca2b7531e32e8aa1ce3e9606c4bdfa36ab063d400b4b27a7"
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
