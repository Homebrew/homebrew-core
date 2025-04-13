class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.9.1.tar.gz"
  sha256 "cb15bd2a4fb48eac138920685ec3fd1088b8c8fe9e67adeea83e6ca720e83cef"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a787941ec42f72413838a5254cfe166b6cb155a90d1622fd69e4bd97e710a4ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a787941ec42f72413838a5254cfe166b6cb155a90d1622fd69e4bd97e710a4ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a787941ec42f72413838a5254cfe166b6cb155a90d1622fd69e4bd97e710a4ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec8463584b8adcb13e34e979e43ac70aca33b83c6f0caf532505bd3c37b8ffd2"
    sha256 cellar: :any_skip_relocation, ventura:       "ec8463584b8adcb13e34e979e43ac70aca33b83c6f0caf532505bd3c37b8ffd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8547d73012bb21152a5a6c5279284792786215386d46e26ceaafb9afa951614"
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
