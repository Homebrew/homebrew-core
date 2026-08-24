class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.17.6.tar.gz"
  sha256 "5fd986644132678b6e80be6dfa5d57253b1640d661053e4820daa57320b42720"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2257b04a2b64e1afff963b37a0c4d21fd9c2a52734c99a3d657a5f4da4a173b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2257b04a2b64e1afff963b37a0c4d21fd9c2a52734c99a3d657a5f4da4a173b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2257b04a2b64e1afff963b37a0c4d21fd9c2a52734c99a3d657a5f4da4a173b"
    sha256 cellar: :any_skip_relocation, sonoma:        "abd845ec0dc7aed313ecf445fcaac178fa62d4c72beb6cc1416a849b79c4d264"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c5688a9fead2b2bd289fbe0f60be95320197ca621b02ac3f1481a2bb6de8257"
    sha256 cellar: :any,                 x86_64_linux:  "838a27fd8c2bf4169769c1e7771ecf4504ab1612af28572ee41ae409d4b99859"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
