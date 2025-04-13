class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "b5985c7d8fb6b42b5995175ab1b761f23e8879f95ddc0acc44a5af4c706c528f"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42ffbb98e33c3681c42c8fe9e4d95e31a7dee7a6d54916f3439e55b459f9db3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42ffbb98e33c3681c42c8fe9e4d95e31a7dee7a6d54916f3439e55b459f9db3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42ffbb98e33c3681c42c8fe9e4d95e31a7dee7a6d54916f3439e55b459f9db3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3731dc8da6b18a92bc89876ccb5f63b433c585036203d4badfd99bef8579a477"
    sha256 cellar: :any_skip_relocation, ventura:       "3731dc8da6b18a92bc89876ccb5f63b433c585036203d4badfd99bef8579a477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76dc8770847e76b0b5d4939fe5d2870958a17cc8408485aec3f4da71c974e90a"
  end

  depends_on "go" => :build
  depends_on "opentofu"

  def install
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
