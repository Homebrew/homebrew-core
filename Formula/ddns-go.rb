class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v5.3.4.tar.gz"
  sha256 "46f41a7dd743e08481e753c7a57ffa6fbc56de6740e120733db55ab5e0b06d16"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f9cd5be5b082a688cc8b11674893c4c0254eb6e56350359907a8401a129c9b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f9cd5be5b082a688cc8b11674893c4c0254eb6e56350359907a8401a129c9b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f9cd5be5b082a688cc8b11674893c4c0254eb6e56350359907a8401a129c9b9"
    sha256 cellar: :any_skip_relocation, ventura:        "3757a4ec9538a88dedc6f73ab1904349345a9c2bdcc8064eb0e101b2ea2456fd"
    sha256 cellar: :any_skip_relocation, monterey:       "3757a4ec9538a88dedc6f73ab1904349345a9c2bdcc8064eb0e101b2ea2456fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "3757a4ec9538a88dedc6f73ab1904349345a9c2bdcc8064eb0e101b2ea2456fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "839fd00f85fabfcab0cf5421411108e63f99b6cb95192822c9a9aec23e692e8e"
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
