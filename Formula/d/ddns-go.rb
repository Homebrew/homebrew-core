class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.3.0.tar.gz"
  sha256 "307a0b045f3631b0f67d566903b80d0ecdd47c8159000ee0d93debe3c59097a0"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59f4aac77da466b6e1830e1760a87d2be3b45790e16791a7989e2f9da7ea0050"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf2d49ce8f41dcb3b29fd94100f03b08b64c209d22ce8f90d8dcc2ca2703c9ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77ea49e053859455020bc8475162a8e294eb31b454250451fea9322b2aae0023"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4be41129303768b7f2d66fc93851c371e6455315e74a0ed60e02cd0733cf362"
    sha256 cellar: :any_skip_relocation, ventura:        "7ec676558d585660689e1514c533cfce63a84cb3307868c75a75db48e4db2e2f"
    sha256 cellar: :any_skip_relocation, monterey:       "01793da14b63ee55526bdbb7c70cd956014dedfcbf600c24c17adfe525bb869e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef1407dcf34a2e1150a45610908feb221462c8e2529853f998b893bdc879162f"
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
