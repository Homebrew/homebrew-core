class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v5.7.0.tar.gz"
  sha256 "c180b3fb35b41907eadcd79e603413489b569aa8ff603409ee83e784c3ab9457"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "550d5defd837205480d7cef4335b229ff264f1b67b17203529e161b7c1d3834e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "717d8eb7f4c360e83cfd9e2273c7f44a49e61089a5d8e5f45107fd2c8a7ee713"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2a44c77ae920f83360b2d1d04261a57a609baafa8f3e89043ae16b8cfcae82e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8d680dc20be4333496f140ef1d232171ae942b6e1a36133b48615852ae70d00"
    sha256 cellar: :any_skip_relocation, ventura:        "0ffc66520995510633a27d38398a63dd3468bee0867338bdfbb59d84663a8157"
    sha256 cellar: :any_skip_relocation, monterey:       "1e4b593de3e8146543f59a05c6ac49ffaa9c04323dff3c71d3afe03753a6e6c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59f0380c281eab78770101ef5758e1e2302a16d021f924927de45a53aa430e90"
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
