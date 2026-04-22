class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "70f9ba95e0fe2dd17328bea831691710007d4c4c2c532b69c67487f78143913f"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52b218d398f837178fcd52a7d42fddb01f0ddf6f244b0391ffccdfa98d3cb868"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52b218d398f837178fcd52a7d42fddb01f0ddf6f244b0391ffccdfa98d3cb868"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52b218d398f837178fcd52a7d42fddb01f0ddf6f244b0391ffccdfa98d3cb868"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1464da44119ec481ee7610ca60a665a1eea368b1e585e273ab77f3519d3ad76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "330ba41851fc0be77a91205fbd28170a30c2738606924de0c3259dda5e2b102f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36daf08edea48a3aa9d862195ad27e0f1443aeb51e6954bfc6b6fb998fbbb723"
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
