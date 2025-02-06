class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.8.1.tar.gz"
  sha256 "583eca3bb3e350c2100a660f8a3ea110ac6829d1200d3539702a81f204e3b673"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5285b5fec9ea54c31a8ce6b6afa64a8975a030f690e6429da16bda942fd6d83c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5285b5fec9ea54c31a8ce6b6afa64a8975a030f690e6429da16bda942fd6d83c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5285b5fec9ea54c31a8ce6b6afa64a8975a030f690e6429da16bda942fd6d83c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c911c8f575a8def8c0eae469bf035fe7387aa719de2b57c8dc555b1884e123ef"
    sha256 cellar: :any_skip_relocation, ventura:       "c911c8f575a8def8c0eae469bf035fe7387aa719de2b57c8dc555b1884e123ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6784e7f1b3482b5738c67e8d9715320fd0e197ca2b44db6f86f53d16870875bf"
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
