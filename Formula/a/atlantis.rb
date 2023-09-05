class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.25.0.tar.gz"
  sha256 "23cbd2f992a1fb90de80fcef8f0ab11024379bae76a2db322c48696b0efb81b7"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b489822a52907f1b643d781c526108da1d9afbe502e37b84bbad58344dadded4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b489822a52907f1b643d781c526108da1d9afbe502e37b84bbad58344dadded4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b489822a52907f1b643d781c526108da1d9afbe502e37b84bbad58344dadded4"
    sha256 cellar: :any_skip_relocation, ventura:        "63981f1a38bf51a5fb9d827e4b784a0384584336b0f40f2b8139e08d892af770"
    sha256 cellar: :any_skip_relocation, monterey:       "63981f1a38bf51a5fb9d827e4b784a0384584336b0f40f2b8139e08d892af770"
    sha256 cellar: :any_skip_relocation, big_sur:        "63981f1a38bf51a5fb9d827e4b784a0384584336b0f40f2b8139e08d892af770"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "994e3fdead7b273047ffed1ced341c3f256d714edfb71467b8abfd468251e3b9"
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
