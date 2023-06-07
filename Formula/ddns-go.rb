class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v5.3.3.tar.gz"
  sha256 "1c7a717b1021ad12dcc05adf9e6940994d6657c0d070d17d30a05abf0f48a9d1"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "552254c427875f8d7f5b025fb01076d3081379f4bf4b115e6e0df4a2414f9162"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "552254c427875f8d7f5b025fb01076d3081379f4bf4b115e6e0df4a2414f9162"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "552254c427875f8d7f5b025fb01076d3081379f4bf4b115e6e0df4a2414f9162"
    sha256 cellar: :any_skip_relocation, ventura:        "0a1883ec5bd7187549c5c3a7c915c9a1205e55a4862894446c4e400f06a01971"
    sha256 cellar: :any_skip_relocation, monterey:       "0a1883ec5bd7187549c5c3a7c915c9a1205e55a4862894446c4e400f06a01971"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a1883ec5bd7187549c5c3a7c915c9a1205e55a4862894446c4e400f06a01971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efa9ce2a49649e8ba0e479a67680ba77446115a56511ba48ff16335e8d668efe"
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
