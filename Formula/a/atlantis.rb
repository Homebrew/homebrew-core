class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "35ee65ebecd4c9999e9841aaa3e5bce626f292de6b4bcf22fd5c4599898f1178"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b7ba09f0d0d86b6e20ecce71f5a1c60f6b4d9d8fb915b50d2713082474456c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b7ba09f0d0d86b6e20ecce71f5a1c60f6b4d9d8fb915b50d2713082474456c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b7ba09f0d0d86b6e20ecce71f5a1c60f6b4d9d8fb915b50d2713082474456c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "36620502559085f9e3607ed68b17c93eb555fee83d6158b7f24986104bc265e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1c65ebca144c3943c39f10d7c6b04271573f00686256f8bd04eb6e9291974f4"
    sha256 cellar: :any,                 x86_64_linux:  "549b7dc6488dd7fa5e7f70f0b6a4e70e60a37da2db684f71a04b3eba7624630f"
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
