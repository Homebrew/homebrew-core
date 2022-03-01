class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.18.3.tar.gz"
  sha256 "979f4fbc7d79b7bc937c86aba2cc288e74b082bbac20937382e3a5a2fc843d40"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eae50154d522413f1c51dbaec0e4ceda2da337c0550319bd1622d8ddc65b5d98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "215a944ca6521de133cdca8f12a00118b3e4783d860b872ea6bae7b5f210e19d"
    sha256 cellar: :any_skip_relocation, monterey:       "2f57963566bbe004982bb308177eb8764bd2946f4ea07e5e0c7c6d922012b1d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "7026e7efba485c9a34712822ac285d5d6c60f97439d3c22fbcc789e7505f03dc"
    sha256 cellar: :any_skip_relocation, catalina:       "258b521bc9b263d62056065dd8744e34325f17ac2f264a6e31cf2990bba8b31d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d03b4a344e8aa6ec8161220cd0f6adfee0a0299efb316aef7b298663393e1f3d"
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
