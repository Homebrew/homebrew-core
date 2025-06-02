class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.9.4.tar.gz"
  sha256 "9430183bc24261060d1ff3353d6d9d1543a608f50d931953d64956629aaa67fe"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f8764d5d9517c5eef19f52ef8b95ca5098500946c272eb2fd8e731ff0be1228"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f8764d5d9517c5eef19f52ef8b95ca5098500946c272eb2fd8e731ff0be1228"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f8764d5d9517c5eef19f52ef8b95ca5098500946c272eb2fd8e731ff0be1228"
    sha256 cellar: :any_skip_relocation, sonoma:        "a35dc633e37a12cdb02e46cedcd9acfeb90b580ee53a9589dc82512ca9506ffb"
    sha256 cellar: :any_skip_relocation, ventura:       "a35dc633e37a12cdb02e46cedcd9acfeb90b580ee53a9589dc82512ca9506ffb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51d76ae1d86f9e568f25ca8a0b8a9b83d410e816f96202eefa581bbd227e3d98"
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
