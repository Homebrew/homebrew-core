class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/refs/tags/v0.28.5.tar.gz"
  sha256 "470f68b302be9c5763a44a093ad4d19d5b72b8cdb7ec8ebecb5f696c9271d952"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8944b3eb13dd3a4f00bc38a39928e112b8a56504bb528a06c6607087aa2f1623"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fae63c353059d260ac09ee900cd3999ba3f6039e64845a5f17e28a56e9700515"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91c2065dba98761a842cc1baabfc15231260ea26cfc496d8cb5e25bf88a1469d"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d69683ed9f877ba2311b9bd03c2af46e54510553f73cbbdf0be54bdc23aaa9c"
    sha256 cellar: :any_skip_relocation, ventura:        "e355f09d29bd18cfc7d81860ec763eba357971f797f0cf3fef9df414ab28bad6"
    sha256 cellar: :any_skip_relocation, monterey:       "0d46861395dd0a8bab9d3df09199997c24bb5e7f43dc05208ca4195f7c410abc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "114770b2f9e60f2473dc385d0ee570b581c83c5c128d864ed8a9e9345971f948"
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
