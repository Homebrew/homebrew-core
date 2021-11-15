class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.17.5.tar.gz"
  sha256 "5420628e4621be8df9ade2f2fa8727f3e75dc77971bc0fa678f3dc03d970850e"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31aba142586f85511773e7c0938aafe55d36a9b5b5e5b791af257d6d7bf7a917"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "518735ba7fd8282f97d6046c165de647414d50afe0dd354f92176341f7202787"
    sha256 cellar: :any_skip_relocation, monterey:       "02ea1cf3092a7adf497364a916e076d383850f2676a8dbb8761ffc890046c385"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab6914d77bbc729ac1a6ee88ff7ee47402aba9134f58ab341fe814571097cd0d"
    sha256 cellar: :any_skip_relocation, catalina:       "da635f12319ba42ea59fb66c7f3b964a4838094c60e95ddbe897c6ab064f5dfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b002b6ed16d07edcba81c9280fad09958be6fc858e550128f92842f7f91d672c"
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
