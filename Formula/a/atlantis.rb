class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "4d88574c79422aa6a362063d5ef3d46a6290c33d2e7918981cf2860a54f2c988"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f229c1f97447dbdaae6512ab07a084c82ecd86285f5aa2106cf8d1649bf0a6c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f229c1f97447dbdaae6512ab07a084c82ecd86285f5aa2106cf8d1649bf0a6c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f229c1f97447dbdaae6512ab07a084c82ecd86285f5aa2106cf8d1649bf0a6c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "746bca9edf042bd509611b44e26cc35c193e42ecc52e8ae0de872cb185ae5e37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8e005e16ebebd41f7b8184d4da05b2ee8d692c6a63d439f078de799dd6722d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a409858aa9c51b8b237fa5a97ced7aeabe89b4c72b0a82f07a2a4ff910ee138b"
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
