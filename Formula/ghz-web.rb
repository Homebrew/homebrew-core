class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.54.1.tar.gz"
  sha256 "b1f56a71abd018141f757e12ffc27e6c001acd4e608ae8b17595bce46935e05d"

  bottle do
    cellar :any_skip_relocation
    sha256 "1eb234719176dae9c96c548031cf0b9620f64d98468bba2506140257af822b59" => :catalina
    sha256 "2f885d0487a6e27ce932f9020b1d3df50f5ba2ea105402f6539cf94eb225cf81" => :mojave
    sha256 "80931f9681d55d88b0b011077c8d228bcb27497df1e3e080485b969e730b812a" => :high_sierra
  end

  depends_on "go" => :build
  depends_on :xcode => :build

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
    assert_match /200 OK/m, shell_output(cmd)
  end
end
