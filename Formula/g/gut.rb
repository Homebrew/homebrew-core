class Gut < Formula
  desc "Beginner friendly porcelain for git"
  homepage "https://gut-cli.dev/"
  url "https://github.com/julien040/gut/archive/refs/tags/0.3.3.tar.gz"
  sha256 "2e5af066ac8bcf46ef15cd9c788e57862c3dcb6119539eac100a71daee148e7d"
  license "MIT"
  head "https://github.com/julien040/gut.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b52619b2c245e7a2984a8063f0172d9f9941c368489e4db8d20a09f2f192cfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b49f2b3e6ee4a6f64b4b1d3405840bac9ecbaf3b01fd5c058b993f8ab76370cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43f63edae2ae746b9229aeb9f5edb7c69cfa9efe511a78c7988b9431956def4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa230eb9193455e7565181555fa4309e1e8cef55f2f71ae8eaa2b777b8193137"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "540101f53289c2d1e17128a7aad270dce4690b839bf4434e6315ea783c38e3c7"
    sha256 cellar: :any,                 x86_64_linux:  "47e60bb427c691d34b2ee0bc629bbba8d33fb07fdeb0cb39f686656aabb67ed3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/julien040/gut/src/telemetry.gutVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gut", shell_parameter_format: :cobra)
  end

  test do
    system bin/"gut", "telemetry", "disable"

    assert_match version.to_s, shell_output("#{bin}/gut --version")

    system "git", "init", "--initial-branch=main"
    system "git", "commit", "--allow-empty", "-m", "test"
    assert_match "on branch main", shell_output("#{bin}/gut whereami")
  end
end
