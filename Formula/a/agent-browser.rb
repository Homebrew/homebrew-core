class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "ed52840279526f057977a98e99d60fe0ab760122ee73ce11f4cf050e47938913"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6531a29e4268607084242c51727791b96e23f94b51cb0f0a0c40e5e5f84d8bb4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1bccb9607d6674514d0070d92dcae4da7ef9339f08ad57003193b26ec812dec4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b0937ff6832ee6f33372fb7ef583a9ecc970a73f51f14d89308b6bd5c4434408"
    sha256 cellar: :any,                 arm64_linux:       "b40c364af70074524745053be3b75e04e7420676113a49418f27bb0429396e49"
    sha256 cellar: :any,                 x86_64_linux:      "20d42dc447024159ad1bcac68f88d6b071ddd8bb30aac2c2e35ea52c296868f0"
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
