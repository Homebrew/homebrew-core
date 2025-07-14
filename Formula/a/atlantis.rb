class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "fa1c94f5d8abb19f71d80aac701fa206fc05341827f052fd009ec8807211e490"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc5b3d84c4ba4cd4e61ebdfe0c8df5ae9a7d8326047320d45a03edff0b9ce7d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc5b3d84c4ba4cd4e61ebdfe0c8df5ae9a7d8326047320d45a03edff0b9ce7d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc5b3d84c4ba4cd4e61ebdfe0c8df5ae9a7d8326047320d45a03edff0b9ce7d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "75687c8cf6457d17334e4971e089081a526dfb641a8ab5f8ed3ad631ace919c8"
    sha256 cellar: :any_skip_relocation, ventura:       "75687c8cf6457d17334e4971e089081a526dfb641a8ab5f8ed3ad631ace919c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e959184196748b8bdb9c141191c03e6d9e8aec02c631f49fca66ad2ada02248"
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
