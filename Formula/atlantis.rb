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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92b373936b46497b893cd73e48b91c639b67e6ae076468220175175d0521896f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1527391690c8b8ee486ab4ad57927fe46d0104aea6a1bd80768cb7163f5eb6e2"
    sha256 cellar: :any_skip_relocation, monterey:       "21245cc4bf8103527d3a1b17de4ad0168142e5c5c5fbab36da7944463dbde3e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8f721a5265c36d37da78f24e5514fa000de2b585a33d9a75300457f405fec5a"
    sha256 cellar: :any_skip_relocation, catalina:       "924a1d4d9e8a73d817efaca7ac08fb948c149cf138cf006faaf37a76c2289db3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84fe1300076bc916f414c41830a933b008fbebe63e7f1606fbeac5f7bf52e04d"
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
