class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.9.0.tar.gz"
  sha256 "6942537ae8708a5b2e4126067bff368f3f8708e015342d56e3ad2865d7b88029"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "835235e0cc2e3fa5e1238c44ceb480c1bb341b85c81df41d5693b67d542b04da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "835235e0cc2e3fa5e1238c44ceb480c1bb341b85c81df41d5693b67d542b04da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "835235e0cc2e3fa5e1238c44ceb480c1bb341b85c81df41d5693b67d542b04da"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab2cbee7f0bbfae2edcba62d9abc0d0fc32467ce565921df6cdb7921fea1641d"
    sha256 cellar: :any_skip_relocation, ventura:       "ab2cbee7f0bbfae2edcba62d9abc0d0fc32467ce565921df6cdb7921fea1641d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7756a6ff25d6e9bebdb5b1f5c07864c99a2c0ce9825d539df19ef4e2e16ba4f3"
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
