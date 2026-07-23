class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.17.2.tar.gz"
  sha256 "d7a8b098797171e715a20a1581b3f44c5c3a8514d93fe64e52ccde92f129bca3"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0b3fd5c630bce613c257f150194c7d326817eb4bb0e14afd62541708090823a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0b3fd5c630bce613c257f150194c7d326817eb4bb0e14afd62541708090823a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0b3fd5c630bce613c257f150194c7d326817eb4bb0e14afd62541708090823a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0fc1313e654b8d6017b9f094c5722f6f8911b9b8d2676e6de4f613b0112ab0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76b73b4d3f3d3b0c9c29854cea05801223bc259a576f2254bfd623c0a2c3d435"
    sha256 cellar: :any,                 x86_64_linux:  "e8dac432bcce18358d07c4c4e852e0c53f9036eb682678e139eeb7057b3c433f"
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
