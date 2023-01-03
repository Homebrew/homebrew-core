class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.22.0.tar.gz"
  sha256 "fcb6698eb12a9ee76880c0c4c3d5cf5345c3f9fa5be9c9d29868c30c97ffefeb"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fed472ecaeacbca3bd4990dab6c180f28b0a00f6dd531e4cdaf8ff26711c190e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f15dcd93a1d5b3809680e611989a6377489647a31082ed7e6d693f3a71bc53e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d80dadc7f4965733c3ef56b0f8c0e767e4bce10c98dc4e0e33c9341f21a5a26c"
    sha256 cellar: :any_skip_relocation, ventura:        "50babd94b2f8b877ef8c6c8cc1459e8cef8da8deb5d0390c37d199d25a3a585e"
    sha256 cellar: :any_skip_relocation, monterey:       "bbba22d0861d796bf779a75b74c07a10660c7b2eed732845703a24669af5f68d"
    sha256 cellar: :any_skip_relocation, big_sur:        "585bf22f7200a0e3145b662c36ff3b3781b84a4ec819a8ecb02810ea85f828ca"
    sha256 cellar: :any_skip_relocation, catalina:       "ba7ae8b722bb4d5a83ac8ac00145e69309947c8fa5159eb2e4ca7a04ecab6eee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b8ba9068f3fbff0aed64a6a5a8c6a4781fc4769082a109cb5862381fa95400d"
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
