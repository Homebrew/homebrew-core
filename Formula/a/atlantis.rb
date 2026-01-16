class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "dbc6cd1e5a9209c5f656205d8165b8092e4710cb4ecc17e54a400e76bf125143"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "405d2b3cc45dc1dcc39f4bc00a872832af27a651f54aac34fb73283149f50307"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "405d2b3cc45dc1dcc39f4bc00a872832af27a651f54aac34fb73283149f50307"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "405d2b3cc45dc1dcc39f4bc00a872832af27a651f54aac34fb73283149f50307"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccf865147c910ed01f1e8075f781bc7e7340fdad89ff4e8f1111bdff2ac21f9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f966431950f722b91d4f49273a9e3be274ae61e508b906c6d7f0279b29ec1cce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b6a7de809ed255eb47e75c394c6c9d540d253fa59005930cf9714a14179776e"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    # The commit variable only displays 7 characters, so we can't use #{tap.user} or "Homebrew".
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"atlantis", shell_parameter_format: :cobra)
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
