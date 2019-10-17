class AnycableGo < Formula
  desc "Anycable Go WebSocket Server"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v0.6.4.tar.gz"
  sha256 "dbcfccdedc7d28d2d70e12a6c2aff77be28a65dcaa27386d3b65465849fff162"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab783dacc5e7118d049c7b0edb4840c5c0e8e63566a82d977e421426887da412" => :catalina
    sha256 "a65ac740e2d0ce092b84c958334418b206f725cf2e6fca77be68f146817a5a88" => :mojave
    sha256 "a9e268c4eb4e313e6fd3b3e6e3508039fb8abb7c0f3ce17f5ce952efc7a5fadc" => :high_sierra
    sha256 "eec5c786934d53b6260727f73f7a08ed29626aef25782687b0f7251b47f42497" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/anycable/anycable-go/").install Dir["*"]
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-o", "#{bin}/anycable-go", "-v", "github.com/anycable/anycable-go/cmd/anycable-go"
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
