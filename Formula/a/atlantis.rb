class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "04d57095bf4163e03188f716b0525235b94624dca2a4137ff9a039aa6a9b1e63"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "393ed05c2d031b79f64d25063b913f167ff79daa210af6d233e42a62f3346800"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "393ed05c2d031b79f64d25063b913f167ff79daa210af6d233e42a62f3346800"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "393ed05c2d031b79f64d25063b913f167ff79daa210af6d233e42a62f3346800"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bb701a05ff9e0c85167bc9b5e84acae7ee091c03ac7e9da7e999b50365845425"
    sha256 cellar: :any,                 x86_64_linux:      "8b5beee3ee9c2c7f9be801716e2e483157e3923856bfe26368cc37a15ef3a3b0"
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
