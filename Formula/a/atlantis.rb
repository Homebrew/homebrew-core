class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "d1c5933f1dca6fe4d869993ca27cbaa829323d24bb93de24a1010ff2a385fff8"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da24ec8752c7c13cb30a1d8ed9b963a631307cadd4cbc347e01c5bffb3811686"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da24ec8752c7c13cb30a1d8ed9b963a631307cadd4cbc347e01c5bffb3811686"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da24ec8752c7c13cb30a1d8ed9b963a631307cadd4cbc347e01c5bffb3811686"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a67adb1f8bc5fed68cf620d6b989d6453a43782596f6344891f658d1e9c8cba"
    sha256 cellar: :any_skip_relocation, ventura:       "3a67adb1f8bc5fed68cf620d6b989d6453a43782596f6344891f658d1e9c8cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1c9fa5d034e2d409228c41e8753b44ee368db4a96dd1a36f3453c0412ec7022"
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
