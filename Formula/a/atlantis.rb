class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "2ce49b9bc08dc547dd3ad8f99edc9bbf4ea325377489e6fe7f605a56d56971cd"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5af804ae1bdb552f368afad71261ed2e83b1a7dd33282da1e198986e832442c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5af804ae1bdb552f368afad71261ed2e83b1a7dd33282da1e198986e832442c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5af804ae1bdb552f368afad71261ed2e83b1a7dd33282da1e198986e832442c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5325f3ee95d3d6f6fa6f6a28aa539b4ba8b6bfede138630b38e889b9597f5d4a"
    sha256 cellar: :any_skip_relocation, ventura:       "5325f3ee95d3d6f6fa6f6a28aa539b4ba8b6bfede138630b38e889b9597f5d4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "751a9e28faf5bca201b29eb78f1fda07508316acb148de716cc35709e476a35b"
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
