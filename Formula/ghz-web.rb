class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.106.1.tar.gz"
  sha256 "23220289e80920650d463413ede616b1b51b8a007301b344f76163b5b27fb0fd"
  license "Apache-2.0"

  livecheck do
    formula "ghz"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8285f3633766ff837be7beeedbbf73031e380a2fb59404a79483b3d2fce6bddc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a52edbc6812470044eb60d879f4e9638cad33637e005db79cc3616657ed91f7"
    sha256 cellar: :any_skip_relocation, monterey:       "591a8d1e2666da7012e5f2a881e3e3ced1b9d4a371fbdcd8c596329523122a28"
    sha256 cellar: :any_skip_relocation, big_sur:        "326a861d13a4da352c085af4a52cec37fb7a34d75981a8b35084150d595fab4b"
    sha256 cellar: :any_skip_relocation, catalina:       "d0c7703e7ed6fad69f5eb5b6d8d7e87805c647809ef89921298148331eba74ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c2c3c3d1998ebd4962be49794eda69b7bd8aa15c7f1331ec8716aad95e9c82f"
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
