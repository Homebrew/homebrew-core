class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "710408feeeb12c23012bf24c57b674561af6076a843203729ba9e201f3ad634b"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c65a1de357b8701e3bfa231d403af4cf3a19cd7ca0d33dc1de44704ead7b4974"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c65a1de357b8701e3bfa231d403af4cf3a19cd7ca0d33dc1de44704ead7b4974"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c65a1de357b8701e3bfa231d403af4cf3a19cd7ca0d33dc1de44704ead7b4974"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f820a1c3f5f82218d25a2c57456a0d5d4326eef449be767b4c1bb75ef552343"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fab9f3c7d443074ea6e780ca96ead6ed9f755fcb1ad3d416071a11ac47e9b74"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/atlantis version")

    port = free_port
    args = %W[
      --atlantis-url http://invalid/
      --port #{port}
      --gh-user INVALID
      --gh-token INVALID
      --gh-webhook-secret INVALID
      --repo-allowlist INVALID
      --log-level info
      --default-tf-distribution opentofu
      --default-tf-version #{Formula["opentofu"].version}
    ]
    pid = spawn(bin/"atlantis", "server", *args)
    sleep 5
    output = shell_output("curl -vk# 'http://localhost:#{port}/' 2>&1")
    assert_match %r{HTTP/1.1 200 OK}m, output
    assert_match "atlantis", output
  ensure
    Process.kill("TERM", pid)
  end
end
