class AnycableGo < Formula
  desc "Anycable Go WebSocket Server"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v0.6.5.tar.gz"
  sha256 "3112a04db1984151b9e4111a0131b711f6a0a79ccf789fbaf6da1ea9e28608dc"
  head "https://github.com/anycable/anycable-go.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c3f6edcc690d9e4f1ecf50fa4625d76d0fca2858a9161685e43e3685b547e05b" => :catalina
    sha256 "f310bb7559e50790bf25124b1ef2565fa7a6ebd4b59f0c251d8bbffd832960de" => :mojave
    sha256 "b3d5e34b11249ddc4e8b9494434cd308719321d63a62788d7bef46bb95155a73" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-ldflags", "-s -w -X main.version=#{version}",
                          "-trimpath", "-o", "#{bin}/anycable-go",
                          "-v", "github.com/anycable/anycable-go/cmd/anycable-go"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/anycable-go --port=#{port}"
    end
    sleep 1
    output = shell_output("curl -sI http://localhost:#{port}/health")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
