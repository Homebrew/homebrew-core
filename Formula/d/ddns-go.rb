class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.8.0.tar.gz"
  sha256 "7ec7134f18a9272fde4eaf0403013b5e3239a9bf1fc2be6ed68acb01ed94ca44"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4cb4b8c76ff6dd60d3b6861ebc612f3cb9e9fba414754376f94352ddb41f2eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4cb4b8c76ff6dd60d3b6861ebc612f3cb9e9fba414754376f94352ddb41f2eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4cb4b8c76ff6dd60d3b6861ebc612f3cb9e9fba414754376f94352ddb41f2eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "648360b7e2eab56c6c16d413f0c4bbb78dfb26b2caf12d407303c5b33bdf09e9"
    sha256 cellar: :any_skip_relocation, ventura:       "648360b7e2eab56c6c16d413f0c4bbb78dfb26b2caf12d407303c5b33bdf09e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1adc5c5eb2bd9a190578b2314ce9d90a1ae43187389501af7249d2fce4a1d5a4"
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
