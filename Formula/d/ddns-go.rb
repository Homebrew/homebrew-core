class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.14.1.tar.gz"
  sha256 "6a38c08e8c2fb17243720a94b0c54b8636019e7a4f151de60271d4ce19a41f48"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db93c00fc1e40fa4962122da09ddf2c34612fac140a1d2190ea603f80edf4c1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db93c00fc1e40fa4962122da09ddf2c34612fac140a1d2190ea603f80edf4c1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db93c00fc1e40fa4962122da09ddf2c34612fac140a1d2190ea603f80edf4c1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c35d2906dd25691d16ffa87410565e0101b7914c6a0c1295c490c439980f1f69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afb22279c4a62949c3d9d5d176931996853528fb4fdf3a136db185669ef297e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f820e46cac37933ae073f079835da111cb9e9f4f6ff0e1da62fcfb7c9517901"
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
