class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "b6120ac5b3d92c6e8619877a95c1fb20e473f8f9d3a982fa6a840969dfe0f149"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77be434530a8aac10a1978a717592387098e4600bc496e1dfefff3d0e0ea428c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77be434530a8aac10a1978a717592387098e4600bc496e1dfefff3d0e0ea428c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77be434530a8aac10a1978a717592387098e4600bc496e1dfefff3d0e0ea428c"
    sha256 cellar: :any_skip_relocation, sonoma:        "207d9283db36f7d4a119ad67ff3ca9c7dd6096d6f115a8a96b5c1f86ae565acd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3a5f1a5c8051138beb0bf4c6958a00f62676ef6f5de276c01ae9cff87301312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f3319b3cc7ca45fb2c2c82641394d0ed8814ff6870a0bb25d1b3cb49a90d27a"
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

    generate_completions_from_executable(bin/"atlantis", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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
