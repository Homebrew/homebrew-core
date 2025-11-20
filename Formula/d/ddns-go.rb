class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.13.2.tar.gz"
  sha256 "a729096b6d0d769223a21dfd82040b264d6f672d6018d08157f400de321d381e"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fa70da4c968bc0a22d4f8a1ce94e3b949c47f58d2b79e03507d3a0acc6ef04c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fa70da4c968bc0a22d4f8a1ce94e3b949c47f58d2b79e03507d3a0acc6ef04c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fa70da4c968bc0a22d4f8a1ce94e3b949c47f58d2b79e03507d3a0acc6ef04c"
    sha256 cellar: :any_skip_relocation, sonoma:        "21c572af67b4b5c1f5c798d05bdcccd31f8bf46551b3acb55068a24998d36540"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e535c0730fe244ea812e334758a50b4ab64f2d5f37aaffd7027534f90bf9e38d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00a185f4a0136b8fa577c3ad1f900d7b0ad24408a57372598a5aa2d23a31b04e"
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
