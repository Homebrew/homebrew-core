class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.19.4.tar.gz"
  sha256 "569e4cdd7c45e943cec519cf7b8c5320a66ffbb8d9b1aa1358443ba0817db8de"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33f170d71e1d01ff7b687078302cee992c05889194e14e1efe0da55de1d71267"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6c4e5f19bd4ee720e8d9024e21fe4d58f8cf44b9c06f7a6fb9fad29d659c077"
    sha256 cellar: :any_skip_relocation, monterey:       "0d91a4999468b42cd2095144044e19abb18f03016a2308d01eb07b3d1d691708"
    sha256 cellar: :any_skip_relocation, big_sur:        "d968fb195f5428245e58c4e0d25d31d9f3532682d671c2b548ad914a4dc9d588"
    sha256 cellar: :any_skip_relocation, catalina:       "6d9febff162fed00784ea8b02f128f65c82e075d93abcb3943d31319f39ad5a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a44643672d8fdda32ea4da3837820367615a809692713822f47f13e42aca032"
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
