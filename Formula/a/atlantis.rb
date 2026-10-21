class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/refs/tags/v0.48.2.tar.gz"
  sha256 "bcc95e4e2b6b2565f58bb9cd2d503a61b6b6e50614ee83380b2f037796e6aa81"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e04e89fec9bc862d1aafa63c91703c4fe8dcfef4ff53db3072d5001d647fad2f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e04e89fec9bc862d1aafa63c91703c4fe8dcfef4ff53db3072d5001d647fad2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e04e89fec9bc862d1aafa63c91703c4fe8dcfef4ff53db3072d5001d647fad2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eca9941ba7d75845e21ed48cb045536cef1bf0376c6b9c06022a47d9deecc1f8"
    sha256 cellar: :any,                 x86_64_linux:      "ffec27efcd18009ab82c3533818d10710b387c7ec8de82ba3d9df3ca556af0b8"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    # The commit variable only displays 7 characters, so we can't use #{tap.user} or "Homebrew".
    ldflags = %W[
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
