class AnycableGo < Formula
  desc "Anycable Go WebSocket Server"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v0.6.2.tar.gz"
  sha256 "cfd88c1f5a1019283b0c57c2582f7060c4469875f84557a82dbd2cbf5d63888f"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd98c50692308e161ab6159c6b9fe0bbe71e523e79ea34830e9a4a6430911308" => :mojave
    sha256 "707697058ace237fdf1e925c3cbb5c222681c4d7c22d41613d991001da422423" => :high_sierra
    sha256 "a58232f946e3036f2a2eded00facdea0e93e5edfb1adeac21cd3908869187ccf" => :sierra
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
