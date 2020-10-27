class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.15.1.tar.gz"
  sha256 "5bb15472f5761bd83d6f4c7a4ff648c257608e260f04f16e8b410d32a09d5561"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7f5145126d1cc314934ad56f4b52e3a2931f843b2179fa36945f7ca9dd8d8cf" => :catalina
    sha256 "dabaa3ed8301fb3de91746512d5298856f6a28a2e9399ce1430539ef5eab99fd" => :mojave
    sha256 "8737a55b922002efb17fe1e087996a5c2fc759e694d94279eb5263c6a9975fa8" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"atlantis"
  end

  test do
    system bin/"atlantis", "version"
    port = free_port
    loglevel = "info"
    gh_args = "--gh-user INVALID --gh-token INVALID --gh-webhook-secret INVALID --repo-whitelist INVALID"
    command = bin/"atlantis server --atlantis-url http://invalid/ --port #{port} #{gh_args} --log-level #{loglevel}"
    pid = Process.spawn(command)
    system "sleep", "5"
    output = `curl -vk# 'http://localhost:#{port}/' 2>&1`
    assert_match %r{HTTP/1.1 200 OK}m, output
    assert_match "atlantis", output
    Process.kill("TERM", pid)
  end
end
