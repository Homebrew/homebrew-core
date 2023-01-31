class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.113.1.tar.gz"
  sha256 "5515be2353f538afd5f51d8ee769dfe46b063582c99fdf892efb2cd3bad83c74"
  license "Apache-2.0"

  livecheck do
    formula "ghz"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0ecb577f8f2e045e843d3da482b4f162f168ddfe3d837ddcd97da1bd98920a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea669c7693c3d10a9818900e56202e321cb89a2cd1a4f514df5ca7ce96c25a1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6079b60f279ca0499931d1150e2bbf7f6c99ec3d508874ee3887428339eb2a7d"
    sha256 cellar: :any_skip_relocation, ventura:        "b1b3b2e954d69db02f83b51671f88bf35cbc3112eb5a225a0ad29494808c6d75"
    sha256 cellar: :any_skip_relocation, monterey:       "0bd540039003b950fed24be2d75756f9cc46e9f8a0409bc6f411e6b4b8b6d56e"
    sha256 cellar: :any_skip_relocation, big_sur:        "64a5583ab3fa1415be46a29e24e9004f511665ce247c84d390a2a01097318d0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9e936dd8f2e170df71ef5e7280196fda62e492f6288e3a4ecdd7caaff556fc1"
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
