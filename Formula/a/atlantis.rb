class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "d40fb5c41321b239c259c369f833512b62813d99bc9c5e513b4ed5e2057b2b14"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "936e027e21b93fcbd120e6f0f29f2b4496f0580df067e31d373c46bc5cb61786"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "936e027e21b93fcbd120e6f0f29f2b4496f0580df067e31d373c46bc5cb61786"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "936e027e21b93fcbd120e6f0f29f2b4496f0580df067e31d373c46bc5cb61786"
    sha256 cellar: :any_skip_relocation, sonoma:        "059fdcea072d170ba82e1bbc2b1a64376ca317c1ab0bde2cf6450c85d9e98443"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3513ea896f10b09ccd8040724441564738911dd5ba577d47a74f1fa63ed06446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db686900c112720258fa4c4b20f23b6c6028082777666efb513502ac5c009bba"
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
