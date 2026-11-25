class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "75f5b5b966bdfb94462c1d0c00b500d463e4499fa2ef9ce3fddbdca278a62b8c"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "399a90feb0f23527b578d406a5138e7ddd01d4c5416a33785b046764602b38ac"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4a0321a58b6ea214d202c97c912590ccadc7c67af2b3aeee28767d93d8892b79"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4a0321a58b6ea214d202c97c912590ccadc7c67af2b3aeee28767d93d8892b79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4a0321a58b6ea214d202c97c912590ccadc7c67af2b3aeee28767d93d8892b79"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7c86f4ef8fdefe4672b60a87ede6522772189cca17f8a2e4a3bb0273c006a349"
    sha256 cellar: :any,                 x86_64_linux:      "08c7253baed2a6fc0ddc6ccf280022d891b570e785749f7e02fac51742a1db81"
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
    with_test_process(bin/"atlantis", "server", *args) do
      sleep 5
      output = shell_output("curl -vk# 'http://localhost:#{port}/' 2>&1")
      assert_match %r{HTTP/1.1 200 OK}m, output
      assert_match "atlantis", output
    end
  end
end
