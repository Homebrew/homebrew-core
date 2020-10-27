class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.62.0.tar.gz"
  sha256 "0dfd8c7f92eab3821d6aab1481a53756c38a9c0f3c7363d14d44b664dec46c71"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "18b27a5c8851a9ef801a34e71e80c53f3534b2c971bca1bcc3794788bc599a6c" => :catalina
    sha256 "21454728ba239f894e548917e7de449bb067e1308c11fee277defd4dfa9a36c8" => :mojave
    sha256 "a8dbf28ece3c44bbbd78217446db5bcb72292c68e107153a36d22d3c7655c668" => :high_sierra
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
