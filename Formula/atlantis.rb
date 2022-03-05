class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.19.0.tar.gz"
  sha256 "72714aad5bd643a0deafc8da6988e0d3194b21737a60f6f89d0139010f3b4131"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcc12c24a94894c6d2e46ba7e925849a178a924c45a4ba9ac90e61f1b96dc41c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b09c4dd7a3a32c4200754b4e0c02ae85d9dd72a6986c4ff8f4e6247ed11ab96a"
    sha256 cellar: :any_skip_relocation, monterey:       "2a37d69d5cff218cf2c3968163955cf41e943c385d40b8896a907c4e9aad17fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "97a356b9e49ad7d5117bab99b5eca29a645518b3a72fd90bd318475039e6076f"
    sha256 cellar: :any_skip_relocation, catalina:       "312ec20001822c97fab61fe507a390df9e324f1871e66bef8e78ce3d3961925b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf5c365cdc3616fcd31da124a1538b09495dcd3606ce7cdafce4db349be2397e"
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
