class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.15.1.tar.gz"
  sha256 "5bb15472f5761bd83d6f4c7a4ff648c257608e260f04f16e8b410d32a09d5561"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "58fcf557c5a06c4dc07552e00fdf303e9c3c6513d046bf2f5afe30f6a2069f1a" => :catalina
    sha256 "6a1425019333fbd2d9078eefee342a751e41aaa969bfe095992672c7e9ce66cb" => :mojave
    sha256 "b5d675ff7507025409fcc72993d8fdc3b54100c18686bc66ff78fdd03f113eb8" => :high_sierra
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
