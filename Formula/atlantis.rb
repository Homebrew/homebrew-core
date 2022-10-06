class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.19.9.tar.gz"
  sha256 "98e1f0f6b721fd3744eb4213673e842388956fad36cab5d91906b9ec2464d8d7"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d5e27d20856a3bde41231a9a8d7275b28e52a94980a870985ef90003a151f00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5cf65246a23c47b4d13fae770932f52014468d4a05c0be894bbb2e3c6edce27b"
    sha256 cellar: :any_skip_relocation, monterey:       "b023d62b5d92cb0c18729915d871c46cffb325fce6eadd2ae487d56a77b27072"
    sha256 cellar: :any_skip_relocation, big_sur:        "65c3b11a5edd5b37b6a069929b32c80073363aff02cd09eeec881a5855a87b0a"
    sha256 cellar: :any_skip_relocation, catalina:       "754760700ca85da0e8e8bb6db060d5311a27147b7ed09e3c50fac1e5d7da9bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1f8da1b30dbb0bb193a55ababd05b63c49987ec44caf84370aa6bee1f606a4a"
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
