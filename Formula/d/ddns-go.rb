class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.17.9.tar.gz"
  sha256 "86899490c9563a9609aa297080d45ce1d2fba871c23e746b26290086ac53cf50"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7289303afcff0668274a8e13ec809373a5f598999a37d8ea7857127f0c34c355"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7289303afcff0668274a8e13ec809373a5f598999a37d8ea7857127f0c34c355"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7289303afcff0668274a8e13ec809373a5f598999a37d8ea7857127f0c34c355"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ba35b3d22b32a34287c23cce4e05c471184fe06c998684f981f8f31fedac61a8"
    sha256 cellar: :any,                 x86_64_linux:      "da5f7bbdb96a35046a7ff11be51d842eeee913114c517c65932b910e6ca72122"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
