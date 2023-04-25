class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.23.5.tar.gz"
  sha256 "77a2ce75131ed7cc5177b1cef5688d266ed425b16f8dd08d2b192981e74b95ea"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5399e8aae1af5087b379851bedcfbcc5c5a8eb4992a566c0a2ecae519811c895"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5399e8aae1af5087b379851bedcfbcc5c5a8eb4992a566c0a2ecae519811c895"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5399e8aae1af5087b379851bedcfbcc5c5a8eb4992a566c0a2ecae519811c895"
    sha256 cellar: :any_skip_relocation, ventura:        "a29e75410c2f0b1df6d1d60c628100a93c57dc0e907dfa07db336c37582a7bb2"
    sha256 cellar: :any_skip_relocation, monterey:       "a29e75410c2f0b1df6d1d60c628100a93c57dc0e907dfa07db336c37582a7bb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "a29e75410c2f0b1df6d1d60c628100a93c57dc0e907dfa07db336c37582a7bb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0731e823ec8dbfc9ea9ba1b8f03033000be3cfcaa211ff7b101eb85aa57248f2"
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
