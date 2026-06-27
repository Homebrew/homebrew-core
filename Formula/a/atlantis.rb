class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/refs/tags/v0.44.1.tar.gz"
  sha256 "02e3f558e3c814d36b35d26c05f5013588e8210976d06d2a35dee4fe3230eda1"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "624a928db491df21e515133de9e7329f6333266c086e9887b227cad99339f5cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "624a928db491df21e515133de9e7329f6333266c086e9887b227cad99339f5cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "624a928db491df21e515133de9e7329f6333266c086e9887b227cad99339f5cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffaa18b34f037b25f1b2dd60ba9ee9f1acec4f7b95d7c84aa9a8929a0c95e32d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "989aff77e668a5753134ec14fb9e01503e7d7bd57c800973c8e1fd4881c7231f"
    sha256 cellar: :any,                 x86_64_linux:  "9cc82fd22782ab5213e900a891b61c3ef8363ae1c00cd3e47efd8439aa1759bb"
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
