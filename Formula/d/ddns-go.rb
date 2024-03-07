class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.2.0.tar.gz"
  sha256 "a595bbe50e8a6782163dd9882accdea24ad7a9488eb06a628b6ee34bd9637beb"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3807afbe8fa7a2b6a6848a95205a299fdafdab9b700575f303575ab63f9c6e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e503c0d903715dc2a69bcfaffa476247ebb124fe911fdb575de93520d7b327e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "616e77ca1c8f8cb7da28a6bb72e8292b8bb5dc462a07387a094353064c96aced"
    sha256 cellar: :any_skip_relocation, sonoma:         "c10cffe75beddcc8f0e901d167acf164852bbdea45ca1d478b39c430df841fca"
    sha256 cellar: :any_skip_relocation, ventura:        "42f3ac5a0ecd25fdc7053edea4d4bb348cab33555fd22dfe559eeafea9bd8b00"
    sha256 cellar: :any_skip_relocation, monterey:       "66f2cb138a118b99a4acad19f6e05379b611a05c7a89b651196fa0392d1294e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "042869c849e3c5d84120b1f1be174b1fe2ed652903a6252f6c94318c8824eda5"
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
