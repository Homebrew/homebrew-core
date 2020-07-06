class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.55.0.tar.gz"
  sha256 "d968e7841ec5c06bed2ab297308defa8ff268acd1ecdc7c003aebfc593f29d5d"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd64ee484257dd934ea0c635171be0eeaab99b5b38fbbe223de2d0937fbed1e4" => :catalina
    sha256 "eb497d7e74d4e3896e164410a8bfa58ceddf44008a49fd0c9ea7ed09ddcafff3" => :mojave
    sha256 "8e49c90d670f36521c6959f2b36d0bf7bc686740775adb069443db7b3cf419f5" => :high_sierra
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
