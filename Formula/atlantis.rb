class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.20.1.tar.gz"
  sha256 "78f7e93f2b3030883386dc96ec03325790b6aa0a77778afea4cb254099c50f23"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "300c62b285262683f6847f8fe8f29c7b526d12b82410358147f8ee141a501a1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b909946d7378be48a8067a7925079cb238fc0afce6ce44cb4fd629655db2e447"
    sha256 cellar: :any_skip_relocation, monterey:       "dfe8554c620b2a5a9337a3ac1373e0f7d7e4427d035addd955705da614dfd6bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "04afa0e0dbbb1e54cc861611aab11189ea1506fbc9e81404a57bcc87f05a426a"
    sha256 cellar: :any_skip_relocation, catalina:       "8b8733588bd829bd44f8a272f7212ad7eee7113e347255b432878a3df3b13bec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e13f8b71036e0b739e8007f16a46e6ba4407e5d3141d5bd00b5355198c396f18"
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
