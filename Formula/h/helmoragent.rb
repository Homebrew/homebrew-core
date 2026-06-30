class Helmoragent < Formula
  desc "Agent watcher for AI-assisted product development"
  homepage "https://github.com/helmorx/agent-os"
  url "https://github.com/helmorx/agent-os/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "6695fec0a230d70442fe488cd9b73605b227169f50443c57d90b12cce864a314"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"helmor"), "./cmd/helmor"
  end

  test do
    assert_match "0.1.2", shell_output("#{bin}/helmor version")
    assert_match "HELMOR Agent OS", shell_output("#{bin}/helmor help")
  end
end
