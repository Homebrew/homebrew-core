class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.23.1.tar.gz"
  sha256 "25f66f79026a23b1fc7f7e5ce49e1b79f90fc0993d0b71df42cdffe7f92c11f5"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da0fc4b81262a99ba7a74f0d2120a6ca1da2dd1262b85d58c8b95d146192dafc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da0fc4b81262a99ba7a74f0d2120a6ca1da2dd1262b85d58c8b95d146192dafc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da0fc4b81262a99ba7a74f0d2120a6ca1da2dd1262b85d58c8b95d146192dafc"
    sha256 cellar: :any_skip_relocation, ventura:        "9cfcc42f646b50b7738457eb68656c86752f0e94c0442240638c7552b0b749e6"
    sha256 cellar: :any_skip_relocation, monterey:       "9cfcc42f646b50b7738457eb68656c86752f0e94c0442240638c7552b0b749e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "9cfcc42f646b50b7738457eb68656c86752f0e94c0442240638c7552b0b749e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64b31c7cf4f39202fe3e074ce8c9db02200d5bdbf760e620c519aafea9f1039c"
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
