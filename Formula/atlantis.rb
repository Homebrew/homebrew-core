class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.17.0.tar.gz"
  sha256 "39d10c691b784bfb2ad5d74539b5b65e80417bf882b234778990235d8a615229"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "08bc8856ba37553d5c57785991a2b25671d617e8abfa43f23505453409bd987f"
    sha256 cellar: :any_skip_relocation, big_sur:       "ebf1cffe6c5210965706e51752a819935659b8dd558d0e6658c5f990ff68deeb"
    sha256 cellar: :any_skip_relocation, catalina:      "e2f76c522af443d89b42acde39ecda5f1fe5c337ec313f7860971a89cc0b4853"
    sha256 cellar: :any_skip_relocation, mojave:        "0535a413cfd9b36fd3a9fa1fdddebb75589f6d18fdc7f8b55c09f663db4b77b3"
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
