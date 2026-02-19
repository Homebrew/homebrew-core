class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/refs/tags/v0.121.0.tar.gz"
  sha256 "d92ed00a2cd1be3b14fe680e1615e9dace4fd4cf6d679811173ae7f2611ad762"
  license "Apache-2.0"
  head "https://github.com/bojand/ghz.git", branch: "master"

  livecheck do
    formula "ghz"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68707a457b2cca1410b4e9543396b8ff3fe23d1361de95cea0fe78f6b3ed3021"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fe4560e10081935d50b7c00f137a11acac1572e42f4810992f49e09e53445cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc5b9ecc777fc22afc966e552d046bbb2c0c8688665f5d60a25fce1893603b15"
    sha256 cellar: :any_skip_relocation, sonoma:        "d806371d45c367541083b4a468fb71751dd19c4983e27d738f45a81d095c4d93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a45d2d2e7fd08237e97f1c531acce46fe6fef742254184e23fcfa246530c250e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c17961aad429eae9fd0ccb439d3ac704df70e8fd6c1adf8fbcf96f516a57d7ca"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ghz-web"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghz-web -v 2>&1")
    port = free_port
    ENV["GHZ_SERVER_PORT"] = port.to_s
    spawn bin/"ghz-web"
    sleep 1
    cmd = "curl -sIm3 -XGET http://localhost:#{port}/"
    assert_match "200 OK", shell_output(cmd)
  end
end
