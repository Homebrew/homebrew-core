class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.3.1.tar.gz"
  sha256 "f1e18c6959dda41cd353eeb162d2a1fffaab1f61d23662fca1d4b036fd584bc0"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c220e634f28eaf8861ce893ff2200d3e958dfc938eed8a3fe132fc359b417270"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9c6a1b625c32dc75ad6bfff0a61497ebbb9a0dc9dcc637362d6743235576eb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "957d6dcf3d1110a703f590e33f3045016e8e628c990c72216414b2415f9e4728"
    sha256 cellar: :any_skip_relocation, sonoma:         "08d51af3a110f012d73c69c6e376c768c08ae4a5113160fb3470b4a028d57d59"
    sha256 cellar: :any_skip_relocation, ventura:        "3c4b427cdc1be9809ebfaedd00b68c337acb84edd4d87819e50b839544ca3277"
    sha256 cellar: :any_skip_relocation, monterey:       "c3e994ebca8cf561c08e976ee6b1e1a56b2e9fc40cd61e8a04f56c48535efc00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d9d68ff3546a61b4a07d9611fdc29e6bdcbffcceca7ee43b0b78e328f5e2ed5"
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
