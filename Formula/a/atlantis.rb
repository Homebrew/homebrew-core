class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "ea16f50ae5cf3fab7137e87a8eea3493721530af393a39a52a238590696a0357"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0ad4f04aa65ad49d1389bcf6bcd27d76b3974383d74fe482c19f971656a626d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0ad4f04aa65ad49d1389bcf6bcd27d76b3974383d74fe482c19f971656a626d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0ad4f04aa65ad49d1389bcf6bcd27d76b3974383d74fe482c19f971656a626d"
    sha256 cellar: :any_skip_relocation, sonoma:        "721b41b1aa8be6b1d4a5659cfc75d72b93905b148714a4baf88f5f5d3c99c699"
    sha256 cellar: :any_skip_relocation, ventura:       "721b41b1aa8be6b1d4a5659cfc75d72b93905b148714a4baf88f5f5d3c99c699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d857dce1fe9db66cd104873cfe80448f116429a0a5405012b07e8397fcb4a27e"
  end

  depends_on "go" => :build

  resource "terraform" do
    # https://www.hashicorp.com/blog/hashicorp-adopts-business-source-license
    # Do not update terraform, it switched to the BUSL license
    # Waiting for https://github.com/runatlantis/atlantis/issues/3741
    url "https://github.com/hashicorp/terraform/archive/refs/tags/v1.5.7.tar.gz"
    sha256 "6742fc87cba5e064455393cda12f0e0241c85a7cb2a3558d13289380bb5f26f5"
  end

  def install
    resource("terraform").stage do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: libexec/"bin/terraform")
    end

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: libexec/"bin/atlantis")

    (bin/"atlantis").write_env_script libexec/"bin/atlantis", PATH: libexec/"bin"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/atlantis version")
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
