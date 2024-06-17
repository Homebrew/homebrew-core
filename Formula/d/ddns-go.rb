class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.6.3.tar.gz"
  sha256 "72ddbcaa380e61c3cda758dbc2d9831e17bceb34ec1e4ff4d0fe9f0ed5f7e913"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "611799d7e239588697f674f9eb34253365ee4aa88c15661dfefa0d43ba083eec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e29686e2d86eea4dc073d703a95aed5b79b677ec61d4fa559b6e6ef5de06b30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f53b60c35be926b485ab3461a699089f6ba47b6b8634bfe31a6dfb3ae84969f"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa2fd7823f88658bcfcec95c3c3f8dec5c034c378df4710d1a44da4812ae6c09"
    sha256 cellar: :any_skip_relocation, ventura:        "c62ee7ff73d57f7835ae03f8be8555cc99362df4d47b552b961d4aa9f9c69295"
    sha256 cellar: :any_skip_relocation, monterey:       "9175e0127f1a9cd2becbe3895609a50ad650a542bcdc6f752c1fc5e28c58a48b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2010444b611961101c6e67ba915ce24dc6e454b89746c860f6795d8b1687bdd"
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
