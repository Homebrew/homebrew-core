class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.22.3.tar.gz"
  sha256 "28bcf3cfefafa31927866e7d56e307851712d7876f6df68bc5c87c4ae22bc885"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62dc2f7d37b7cd22ae6f9b73f4361024877ab7502d7919e638ad543a52578e33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bb4f1abd1e1c9f459bae9d41e02b51c86a71aefce746c547a799b834b4df3c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4140a906116dcfed0f2e2794dd240fb81c644ec71e15545d6bb8edfdea86dfac"
    sha256 cellar: :any_skip_relocation, ventura:        "46073b13ce4450ae3703fc6b7d6c016c8e61b438f3b9e8469d2e1a2c4a8d102e"
    sha256 cellar: :any_skip_relocation, monterey:       "6e0bfbc44592dfc23ff4ee4e614c368c79f31b9f5f1e53da24403141655a7434"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e88676087ce86b96c148b3c23c707349775cec08e006572f1ccb9e4d37b70ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e23beac53c1bda1ee8a86f5b9896be85d9f8de0940c1a1183fe64bdaf46c63ef"
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"atlantis", "version"
    port = free_port
    loglevel = "info"
    gh_args = "--gh-user INVALID --gh-token INVALID --gh-webhook-secret INVALID --repo-allowlist INVALID"
    command = bin/"atlantis server --atlantis-url http://invalid/ --port #{port} #{gh_args} --log-level #{loglevel}"
    pid = Process.spawn(command)
    system "sleep", "5"
    output = `curl -vk# 'http://localhost:#{port}/' 2>&1`
    assert_match %r{HTTP/1.1 200 OK}m, output
    assert_match "atlantis", output
    Process.kill("TERM", pid)
  end
end
