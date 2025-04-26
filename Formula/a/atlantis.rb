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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8ca407cd145a50b557c01c069fb0616f17df02a06a3a5729dfff34c54e98246"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8ca407cd145a50b557c01c069fb0616f17df02a06a3a5729dfff34c54e98246"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8ca407cd145a50b557c01c069fb0616f17df02a06a3a5729dfff34c54e98246"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff96e80c18e57f55e6be966d4ef62c8b0d0565b209dec0485bd51e805a172582"
    sha256 cellar: :any_skip_relocation, ventura:       "ff96e80c18e57f55e6be966d4ef62c8b0d0565b209dec0485bd51e805a172582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d60c3d551d569050ac1ea9d7ac02a86aa22e22936381feeb4342cfed293527bb"
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
