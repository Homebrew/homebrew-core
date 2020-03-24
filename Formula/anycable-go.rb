class AnycableGo < Formula
  desc "Anycable Go WebSocket Server"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v0.6.4.tar.gz"
  sha256 "dbcfccdedc7d28d2d70e12a6c2aff77be28a65dcaa27386d3b65465849fff162"
  head "https://github.com/anycable/anycable-go.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7b15a2340fa1fb7ecf97079a1cedbdef0c1f1cf7379f847e70b3f44f08b141e0" => :catalina
    sha256 "12e069a770ebdd191bc1d6ffbe5de94242e5d54c1e4d8b46600d133fc4d92871" => :mojave
    sha256 "0ca4a9b558458aa15fbf81ff5aeabff78102fb6031a5c8295b65c2d9f6c558df" => :high_sierra
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
