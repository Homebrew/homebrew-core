class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.16.2.tar.gz"
  sha256 "1a92f53e50c8ca81e20c15c6dbaf490544f1a7b7b8c8d1c4c60ad8f1bc890276"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "931b1b296ae382bb473d5e77ed471332b33903253532f698f554379c98709931"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "931b1b296ae382bb473d5e77ed471332b33903253532f698f554379c98709931"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "931b1b296ae382bb473d5e77ed471332b33903253532f698f554379c98709931"
    sha256 cellar: :any_skip_relocation, sonoma:        "58294feb3e5baa534e2e19d594341f610d41e06dd206098488440fd90cebd988"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2450e806562b221b17adb6ec1244f1c30ee5ed8dbcecfd620a67ea19f6a78e72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4de3a0c7518830b086fd3c99e859fc048f554c76607af99f9e45a7d070f8f31a"
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
