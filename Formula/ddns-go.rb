class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v5.3.5.tar.gz"
  sha256 "caff2a52b7320ccf7fc95c5572acad8e31e73ecef8b8295d6c7785fbb43bef74"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfbb16eb62f9a97566647b1df4b93ebb0fcf32113c7f034e0693eaf830f30775"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfbb16eb62f9a97566647b1df4b93ebb0fcf32113c7f034e0693eaf830f30775"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfbb16eb62f9a97566647b1df4b93ebb0fcf32113c7f034e0693eaf830f30775"
    sha256 cellar: :any_skip_relocation, ventura:        "95361f881526e217a827b618a88a69e4aacc59b785002a980f952402265a90fc"
    sha256 cellar: :any_skip_relocation, monterey:       "95361f881526e217a827b618a88a69e4aacc59b785002a980f952402265a90fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "95361f881526e217a827b618a88a69e4aacc59b785002a980f952402265a90fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60dcaa46ae542239dc84fc900694e198e4152d0c814515e1badc9696f92a1cd5"
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
