class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.55.0.tar.gz"
  sha256 "d968e7841ec5c06bed2ab297308defa8ff268acd1ecdc7c003aebfc593f29d5d"

  bottle do
    cellar :any_skip_relocation
    sha256 "f2e695bd2b919065e7fef4456aaa9cf59ee2baaa541570201044ab6d9c65b6c7" => :catalina
    sha256 "3fa24df881a970093f04a862ac9fa273111aa4ed377812736dd81b90a8801a8a" => :mojave
    sha256 "e036e428938c14eb5c8b4d5c260634807d569377b3ea7cf0928c42020f6546ca" => :high_sierra
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
