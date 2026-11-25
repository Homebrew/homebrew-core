class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "5e2a2e2edd9ae87a9f92da34ecee02ef4299ee1c0a8cbebae1b7d63c561d6ba9"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "2c956ad5a6b37e509bb9c9b74213371b47cce3fff8d018d8a58a11a4cbfe6438"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "336922aefde48d8b127cc1de10d60eacaa8a5f04c48cee67b1fe613ad436a3bb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dfba18e3b4555450485bb049226d44c9e0627545abbe2c80b4f3ca913b40d6ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1ca8943d54966b079f601af0befb957a024dd6f8a277d4b20d6a1c3ed07f78c1"
    sha256 cellar: :any,                 arm64_linux:       "8994c5fc6996054461c8d763fbeaa3a7d2d10f7ce8f43cce728de1669a4bc139"
    sha256 cellar: :any,                 x86_64_linux:      "50a8aa0a3053bd3e57697065713fa44899b0c055391e5c3b2e6529e9c48c8fa1"
  end

  depends_on "pnpm@11" => :build
  depends_on "rust" => :build
  depends_on "node"

  allow_network_access! :build

  def install
    # Build the dashboard before Cargo embeds it in the native CLI.
    system "pnpm", "install", "--frozen-lockfile", "--filter", "dashboard", "--ignore-scripts"
    # Homebrew places HOME inside the workspace, so Next needs an explicit root.
    inreplace "packages/dashboard/next.config.ts", '  output: "export",',
              "  output: \"export\",\n  turbopack: { root: #{buildpath.to_s.inspect} },"
    system "pnpm", "run", "build:dashboard"

    # Install the source-built CLI instead of npm's prebuilt platform packages.
    system "cargo", "install", *std_cargo_args(path: "cli", root: libexec)
    libexec.install "skills", "skill-data"
    bin.install_symlink libexec/"bin/agent-browser"
  end

  def caveats
    <<~EOS
      To complete the installation, run:
        agent-browser install
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agent-browser --version")

    sessions = JSON.parse(shell_output("#{bin}/agent-browser --json session list"))
    assert_equal true, sessions["success"]
    assert_empty sessions.dig("data", "sessions")

    skill = JSON.parse(shell_output("#{bin}/agent-browser --json skills get core"))
    assert_equal true, skill["success"]
    assert_equal "core", skill["data"].first["name"]

    shell_output("#{bin}/agent-browser nonexistentcommand 2>&1", 1)
  end
end
