class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.109.0.tar.gz"
  sha256 "4b0b3c651861923a60ca3370de652eb9f3eb5b0c7510c877ec1af8d82508fd08"
  license "Apache-2.0"

  livecheck do
    formula "ghz"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f108c055bd3bb0db3a8628545bad677a5356c96556fb1e0b1c6aa857d8b23483"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74703b438207f02c472284e3009c75095c0ace59742ca5ec46f45cdc4ecc498a"
    sha256 cellar: :any_skip_relocation, monterey:       "ddf4a57ae528220891651468f31e68e507d303550a0d71a86ab329a45bf50d4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "90590581331fc2badc0db5cb7716917482967b85bdc50ef7b666213684cfe990"
    sha256 cellar: :any_skip_relocation, catalina:       "f7c8902ec49069cb97436c3b0714d74336ed6ed4f045864c5e9c826b979c5801"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eeea450874c9329a115985e9d9af778291d9d6e65c85c0f51d37bca5aaae8ccd"
  end

  depends_on "go" => :build
  depends_on xcode: :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build",
      "-ldflags", "-s -w -X main.version=#{version}",
      *std_go_args,
      "cmd/ghz-web/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghz-web -v 2>&1")
    port = free_port
    ENV["GHZ_SERVER_PORT"] = port.to_s
    fork do
      exec "#{bin}/ghz-web"
    end
    sleep 1
    cmd = "curl -sIm3 -XGET http://localhost:#{port}/"
    assert_match "200 OK", shell_output(cmd)
  end
end
