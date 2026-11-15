class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "56b934e1c94cb4e10d912c0158a74f8b727e430e6d9c8aff5bfb99e124fa3ace"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "97e3977accb34dc635eaea539d4167b996b41a603730b63180b2af961f860685"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "97e3977accb34dc635eaea539d4167b996b41a603730b63180b2af961f860685"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "97e3977accb34dc635eaea539d4167b996b41a603730b63180b2af961f860685"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "16efbc0feb4996bb70adfd4aa1a42c6fa165735da4effad8dcbe72eec2f55e9a"
    sha256 cellar: :any,                 x86_64_linux:      "0da6f764130e41254ab244f7910019bbf693e217a318c8b1a68c40707331a2d7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "generate", "./..."
    ldflags = %W[-X main.version=#{version}]
    system "go", "build", *std_go_args(ldflags:, tags: "release"), "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end
