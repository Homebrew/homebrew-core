class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.2.1.tar.gz"
  sha256 "07e214813d1b06023944c7908bc4bb4243e61bdfa9c975e54b4515ec6b1aaa04"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef2b5b6c1b7a713ef9902ac03ded01776e8a34e609b3896dd6697fdd83f08a9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9504c6d47fad338cd762d197860d9b92e45f6377842e10f3d2bb1990a95b12d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc0663ea000c83f6114c85196dbc5f9478f4b0677328e97a85a1b17d7aad1f08"
    sha256 cellar: :any_skip_relocation, sonoma:         "944dcb88a8a670e3fcb2c57743d970b38adfa5d728e9590fb615c8bb96f47f12"
    sha256 cellar: :any_skip_relocation, ventura:        "821a5370eeeda0d6a4d478d5111157434f18a27f9e1adf2d299333fa2608fec4"
    sha256 cellar: :any_skip_relocation, monterey:       "4edbaec3a692dcb79085246978258afa0fa5fd815629ec6b1f0e8748f7abacaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00270b646cde7cbb6ffc047bff47cfcd5fb1b46704bcb4ba7c7e1a44c266fb2b"
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
