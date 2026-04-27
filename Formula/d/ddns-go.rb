class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.16.12.tar.gz"
  sha256 "709f4fde4eebc415c592252232f7f79629a64ce9933a30bc68a6cad3198a0c66"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0941330e4dc7921c32b77e998e3efd28523c337a968e7640ba339a54ee37482e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0941330e4dc7921c32b77e998e3efd28523c337a968e7640ba339a54ee37482e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0941330e4dc7921c32b77e998e3efd28523c337a968e7640ba339a54ee37482e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e4fad7219e39b8720c470cd6d3c61c029e27f4ac7048cc46957893e21f7d2eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f54dafb7b5c0e74b1c792e2724d93300fd7112afdf6e45d2ab39aa849ae94c73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d44c08e12a71582487e6d5a32a68bd0922983d87032fa1c7fec61c2669445128"
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
