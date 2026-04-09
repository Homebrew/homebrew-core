class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "6e6e6c2dedab1ad952f3a05142bd41246fb98cff94e7c330efa17f84fe0883b9"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72d45202e2ea012d7c23aac0206c78b89e7cdc2584b03ddac55ace1e34c9e214"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72d45202e2ea012d7c23aac0206c78b89e7cdc2584b03ddac55ace1e34c9e214"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72d45202e2ea012d7c23aac0206c78b89e7cdc2584b03ddac55ace1e34c9e214"
    sha256 cellar: :any_skip_relocation, sonoma:        "19a512487e340522a06d1cfd2649c88afa290c6d0359b541b9db4825bbded9c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "745edc790f78e422b12721b788a1c5e777b2a3d148e6a841ba60a9c11326c297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01753fa3e5183f7d7f4b622e641fc43a8d9d80239a8d4743610e02b4eff84221"
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
