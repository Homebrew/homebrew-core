class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.7.2.tar.gz"
  sha256 "c583aa1dd160e1a87f4ed3a1ec4b7342c14a5c732f3929f435418a109d3a2a55"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0737f338375902506726a7df61d2a10e555a2a0900c7315b5c34cae0499c4638"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0737f338375902506726a7df61d2a10e555a2a0900c7315b5c34cae0499c4638"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0737f338375902506726a7df61d2a10e555a2a0900c7315b5c34cae0499c4638"
    sha256 cellar: :any_skip_relocation, sonoma:        "091c2da6435cd63d65d6fea6ca51023bd7e48289561ddace3f1c7798192982bc"
    sha256 cellar: :any_skip_relocation, ventura:       "091c2da6435cd63d65d6fea6ca51023bd7e48289561ddace3f1c7798192982bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adc7f6fef1a4fdca19ac80e351707dee9dcfe47e7a243d0fff377bc9ff006f95"
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
