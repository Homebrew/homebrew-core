class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.23.2.tar.gz"
  sha256 "336b72b4ba2018b55d1106fb4b92d8ed41abae35a930bd0086ad32c6e979c0ea"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9846e5e1c2e988e2d3d2ac25b26257a54a269973a61064ff515914df829200b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9846e5e1c2e988e2d3d2ac25b26257a54a269973a61064ff515914df829200b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9846e5e1c2e988e2d3d2ac25b26257a54a269973a61064ff515914df829200b"
    sha256 cellar: :any_skip_relocation, ventura:        "92eeaa18aff0ccdf83ddb7a20a8d92e56b13b869a368440c66c455e2654c7c42"
    sha256 cellar: :any_skip_relocation, monterey:       "92eeaa18aff0ccdf83ddb7a20a8d92e56b13b869a368440c66c455e2654c7c42"
    sha256 cellar: :any_skip_relocation, big_sur:        "92eeaa18aff0ccdf83ddb7a20a8d92e56b13b869a368440c66c455e2654c7c42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d66c14d8bde79b75d3573f07c66266c0dea2f294e0148b4a60c300383091ef57"
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
