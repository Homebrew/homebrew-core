class AnycableGo < Formula
  desc "Anycable Go WebSocket Server"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v0.6.3.tar.gz"
  sha256 "ac275a1120457a612a3058cfd7e1d5b7fe0a82d29b9bbe0eab45d9a87e1193a5"

  bottle do
    cellar :any_skip_relocation
    sha256 "c49295eaf552089dfed603b99f9e345a917f59954ecbf30b6f78692c73560743" => :mojave
    sha256 "97cb84b35c1b36680e3179564f1ecb701d547e1eba520b5f411af572a4315088" => :high_sierra
    sha256 "cf2d7d9ece830f8faacd8bddab20effce08293986e81164b84cc8d6dae01e321" => :sierra
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
