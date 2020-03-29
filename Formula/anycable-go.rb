class AnycableGo < Formula
  desc "Anycable Go WebSocket Server"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v0.6.5.tar.gz"
  sha256 "3112a04db1984151b9e4111a0131b711f6a0a79ccf789fbaf6da1ea9e28608dc"
  head "https://github.com/anycable/anycable-go.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d37c08d9889afb6475b800b11f428860c1609ca4d4bcab7f98bef2aeee06578" => :catalina
    sha256 "4ea94e2657ed7d593601ceee6d499debb3b91a22c5af1f63ddb0dfa0e8aff288" => :mojave
    sha256 "63b38c851a6bff06de8d7e229c4d91e0b775f47d76c48517ce6be33cf1c095c5" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-ldflags", "-s -w -X main.version=#{version}",
                          "-trimpath", "-o", "#{bin}/anycable-go",
                          "-v", "github.com/anycable/anycable-go/cmd/anycable-go"
  end

  test do
    pid = fork do
      exec "#{bin}/anycable-go"
    end
    sleep 1
    output = shell_output("curl -sI http://localhost:8080/health")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
