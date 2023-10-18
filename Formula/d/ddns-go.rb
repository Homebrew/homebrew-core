class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v5.6.3.tar.gz"
  sha256 "f0c87a4f9982b85d62295bed4fbd4805671f5d6d45a03857b7cc257c00615bed"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff009ab3b095190d080db6bd81afd3125498aa0e6bdcdf7179371565a8456fcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01618c79066dc2a7b21260f79b1431e19183b0b4ff7f768675735b13979f111c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e7c16fad14c69fd1e02ea0b5a9156f7a0b4ed6051f22dcf65a42655f2db667a"
    sha256 cellar: :any_skip_relocation, sonoma:         "80c6a5402f7dffe13bf53bcabce118a42d65bb946fcd7a6cb7dc24f218bb2be4"
    sha256 cellar: :any_skip_relocation, ventura:        "50faecf30946a19baa8c34e0e9108a79e9ef3aa1dfea3cb792cb9df84f633dea"
    sha256 cellar: :any_skip_relocation, monterey:       "e0ed91cd8682b2ad8772b584f57c30fcfaf45e4b6fa92eb53c74de454880594a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "342340bf9383b439b0efc52a865504f849f89055423891bf21d58e17bf7bb441"
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
