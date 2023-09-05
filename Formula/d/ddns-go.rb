class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v5.6.1.tar.gz"
  sha256 "bbdd92b79d427093e35c4c70c57e3b5d4773b854194268b7d68ec7ca6a57c3c7"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c822a1a462a3364d8da37082516f6a3c4fcf983a7748b9a056aa276b387c9cc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "460015fb92950ba46d9b87a1b0d3c230feba7f4228349331b116b12d78edb44d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4f9718aaa273f2c9722909fbc6e8145dc456d15636cb61d50e098c01cc9813e"
    sha256 cellar: :any_skip_relocation, ventura:        "1ccf13d572d9738727edf26eb1387667f27c7f7ed9df1258279fa959c270191a"
    sha256 cellar: :any_skip_relocation, monterey:       "046799aba35db7e447e2e38ea5567ebe518ac1691f0496347737e2efda0be99e"
    sha256 cellar: :any_skip_relocation, big_sur:        "50423f72b26bf125878a8ce7609c54a8d6a44ad2e05706b5f892b387cd15486d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb4c32f1fb78358765ec707c2eda2a161ceaf48c62aab4ba80344935b6b7c8bf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ddns-go -v")

    port = free_port
    spawn "#{bin}/ddns-go -l :#{port} -c #{testpath}/ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}/clearLog"
    output = shell_output("curl --silent localhost:#{port}/logs")
    assert_equal "[]", output
  end
end
