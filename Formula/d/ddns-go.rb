class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.2.1.tar.gz"
  sha256 "07e214813d1b06023944c7908bc4bb4243e61bdfa9c975e54b4515ec6b1aaa04"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8addd91dfadfb65e83b4794fa5239fd3b658cddc3425680e6938d6ef821b2e9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e84154c92de87ec0efeecea457490bf32cd2e58826a7c649bed4f0c1ea383bed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df956e32e447eb3f8d31c977e4139243e9e7d24f9d37dac6d722f25088433a6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "6bb9b96be56a5bd7dfe367bf34bb6ab5bcd95a7b9c7069425710f04b7c6e37a3"
    sha256 cellar: :any_skip_relocation, ventura:        "f7bc94eadd2f50318326900cd51ada7f1cf5b8b8ff0b18fe7bde94ba69e38b7d"
    sha256 cellar: :any_skip_relocation, monterey:       "b1f6eca241c061f98da4ff73f2476b08f6df9a57d0cac6c8f38038d2b64ca794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dbaedb57800d38cb1b493164c45fde1e0f060c804c6a5b5c9ef8e0cf52b4ac9"
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
    assert_equal "[]", output
  end
end
