class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.3.0.tar.gz"
  sha256 "307a0b045f3631b0f67d566903b80d0ecdd47c8159000ee0d93debe3c59097a0"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad2f5f6cd7057c8c2d76bf410b2b5d591221af3bec4e35414c9cadf7e3e1a725"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f743dc023860dba5170039a1e7376b8de0b1caa5d10504d6355abdf9c83cb7b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9837ac17281d51b40cafaa37c07067da7ac5a17665475742a278c76cab5f233f"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa8a44bf02b637dde354f44712734227589e488d6f3c2b634eb166949bcfa6d1"
    sha256 cellar: :any_skip_relocation, ventura:        "9fe4237b6e2f531ca56bf4eb68e72260a9f4fc86e3558e9a58e36569fa2b2940"
    sha256 cellar: :any_skip_relocation, monterey:       "d0a6fec39f7bda51a8ade68149553e38c33156eb372da8a6321d54562538362d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b22324175795fe51a7021a380f8bd2ddafa9b3ccb05f387916fd02275fddba3"
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
