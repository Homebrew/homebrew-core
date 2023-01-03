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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1c68d1634a4fe86b229ed5254b7dc31c134ce8c4bc3b505336463d89e644f6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9ad78c3bafe84218c96102af4dbdb82ae982e99cab3b07158eb35e7a512deb1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66ff48e495f2e3eb3d47d5565cab690dc73152279a6135f6df0ecc33b3bd0454"
    sha256 cellar: :any_skip_relocation, ventura:        "4816d3eb0eace81347098a5606f3d1f7b0289beb9dab58baf730cbcb61d7156a"
    sha256 cellar: :any_skip_relocation, monterey:       "60f6e9a62a1e9d4f4360e681064f850b8d57ee5300c7d34c3ee3ba0a3d335960"
    sha256 cellar: :any_skip_relocation, big_sur:        "64f1a44b5e828a89a989edff0e1cb9464c87cbb2b8b38195dca7cb54eb136f7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d22ce40e46651891eac673332a821515d3933d420b94bc60d0036a90643596f"
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
