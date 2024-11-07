class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.7.6.tar.gz"
  sha256 "8cb4cf2ba31fe351c01abc567600240951729c0e56180eb6a6ffbd8a8a22271d"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d92a6c90857e8ed477cf0e2a347875cc7b22455d5ef99a30384c9d80d698d3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d92a6c90857e8ed477cf0e2a347875cc7b22455d5ef99a30384c9d80d698d3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d92a6c90857e8ed477cf0e2a347875cc7b22455d5ef99a30384c9d80d698d3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ac553fb74364037f2d539cdb984142daaa3599f6a0edb53bc18fff85647831f"
    sha256 cellar: :any_skip_relocation, ventura:       "0ac553fb74364037f2d539cdb984142daaa3599f6a0edb53bc18fff85647831f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6354b5f1024592f0098e4ff4193257104b7f4653f03c86e374c9cd74124ac5ab"
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
