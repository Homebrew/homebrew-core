class AnycableGo < Formula
  desc "Anycable Go WebSocket Server"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v0.6.1.tar.gz"
  sha256 "609e09d3f6f37900ee02590efe75e5792c1fda52bce4bbb4075d2523c8fbd3bf"

  bottle do
    cellar :any_skip_relocation
    sha256 "7135382ab3246162a827b707e4eb1b6197d061b06d83fc4b580b8e9bec8f3ca5" => :mojave
    sha256 "5ee790ab1c455cb125e1c3a52e4cbb47426c6a5bd51f74f00853bebd75ed9523" => :high_sierra
    sha256 "03f1dc7e44d72166e75de663a9506fb6de48d2c60a1331dc60d9184c4f884358" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/anycable/anycable-go/").install Dir["*"]
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-o", "#{bin}/anycable-go", "-v", "github.com/anycable/anycable-go/cmd/anycable-go"
  end

  test do
    begin
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
end
