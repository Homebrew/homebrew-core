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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a9a0c157c6a2fd2d3a36a31b768d4e648bab79d4b105bda588b11ec79365d89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5dd0cb4514d19107aff8edebcb9ad145384d58b448e51bb0a550dee7598df0b"
    sha256 cellar: :any_skip_relocation, monterey:       "2f8d85245fd4247529716a3fc78eb12610c168f74dc6ebe5f57bf21ca9c0f429"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d1b9a117a1f172b6705953d513f47849ddbeab200268411150484468534d721"
    sha256 cellar: :any_skip_relocation, catalina:       "a707d49925f0e083f7b065dbdc380b091de97a7cc60ae6a2b1e9e48f10560321"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e60258ab11a6f127ecc788ef7c9b351eab391046edea7b1b874cc1c8f4d883b"
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
