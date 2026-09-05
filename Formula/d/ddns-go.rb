class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.17.7.tar.gz"
  sha256 "f7001004e092d9641aad5a94158e0b4cae4a53a7f5c7d96d5c6af3d246c56fcc"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f76decf7b0199f757b948e250f42fbb38cb69f50a9dd151d3c3932353dbc31a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f76decf7b0199f757b948e250f42fbb38cb69f50a9dd151d3c3932353dbc31a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f76decf7b0199f757b948e250f42fbb38cb69f50a9dd151d3c3932353dbc31a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1aafdbc92d8ee5fa87bd74580c76c5f739b27a7902cf0cfa8420b7e32a7f158"
    sha256 cellar: :any,                 x86_64_linux:  "03a695e963b63059980085d3cbef9a1d74c8a78f71cbc76d58194e73133dcbf0"
  end

  depends_on "go" => :build

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
