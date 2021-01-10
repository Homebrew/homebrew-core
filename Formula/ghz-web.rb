class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.90.0.tar.gz"
  sha256 "fbfd832bd81d4ae5b9bcd90b6a441dcfcd63e6519eda16dcab6282ddb06cbc8f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7925aea08ef483065d9d6c9b54e914f90e51859603c5508fd660d6a16372e28" => :big_sur
    sha256 "64ac5d0c29fccbce95b80f30b726d3eff6157b07046da4b4d3acbb2d56aea337" => :arm64_big_sur
    sha256 "22c392cb2cc1085d1410f7d2c1aaffa946341432039b32b06b6a47f2ebf38942" => :catalina
    sha256 "441215fc9a45d73768704ab4dcf2565946793b85d9d03bf4863f26cf787e85dc" => :mojave
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
    assert_match /200 OK/m, shell_output(cmd)
  end
end
