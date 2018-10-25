class AnycableGo < Formula
  desc "Anycable Go WebSocket Server"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v0.6.1.tar.gz"
  sha256 "609e09d3f6f37900ee02590efe75e5792c1fda52bce4bbb4075d2523c8fbd3bf"

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
