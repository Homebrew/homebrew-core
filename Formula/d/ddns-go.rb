class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.5.0.tar.gz"
  sha256 "4f9b7762431a4a75a59ea050b3e41a2d6fa790e212d3ce8aa21f02b6e01f01ea"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93d029018146b85f1b78bcb36ca5826a283afbf5fbd7b8b7185daa0bae1bcaf7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0314db6c64f5d0af6ade5bc2c2738ece49555dabdd8978be93c0f803a2b17ca1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba42b0cd97eb372574d5873b2c9b68c9f4043eb8f41ad88ab2c40505a6385c26"
    sha256 cellar: :any_skip_relocation, sonoma:         "d01dfafb04a70f4505510daff19664fbab1391f68d8333b59def368191e28c81"
    sha256 cellar: :any_skip_relocation, ventura:        "e8d7012f4387b8a96d143cae14d8253af19f1dfe048c26437c5c1c2549095ef7"
    sha256 cellar: :any_skip_relocation, monterey:       "98da9804b2ae1125a1ba6c5d981a211c3942747ef599d0636d44712579b95c09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a3ed7efe95bbc087998685c5e510147264455f1ef33d2873e6a0325d01498aa"
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
