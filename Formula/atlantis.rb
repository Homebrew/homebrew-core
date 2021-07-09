class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.17.2.tar.gz"
  sha256 "7dcba88cbcad2f7830bbc4e42839593a912c5419f0e1d49796f2a7b27203cf3f"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0e1f196a5494132156d664e66871244352d59a1d9606fb72bf148190add97a7d"
    sha256 cellar: :any_skip_relocation, big_sur:       "b97db8a025b7d52cd5d01f27506f44f922453b26995b7282e95526f74f027c69"
    sha256 cellar: :any_skip_relocation, catalina:      "ab59468b03fe78a253123c3886887b66c4c19c4b30599c4f899be0019bf836da"
    sha256 cellar: :any_skip_relocation, mojave:        "9ca8bcd80bb64544b6ca731a248a42b101b5e98cfb6931c55e46d35c89402646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f9e89a7a52f1df0b884f40caf8a333959cfb6f16c66cb57f9cbb565fc2a31f1"
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
