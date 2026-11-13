class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "ed52840279526f057977a98e99d60fe0ab760122ee73ce11f4cf050e47938913"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5a2dce35c32c38775fa38d01daae7a5acae8e7841f502c68fdf45a3bc4e0ae15"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9fd277a1fc73e5127d1fae8cb9d02d97039ee51877fe5f170c925b1fed1ff481"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ae744b83c09bbcb6cd03abe85c19a6bf2cc50493dc7022ec535f1d55f3c118a3"
    sha256 cellar: :any,                 arm64_linux:       "04e9c96949d437bcb1bda9f3f0e9f0fabb32fcaf4d0ed3b140763cc3e4bc62f0"
    sha256 cellar: :any,                 x86_64_linux:      "73b6cebfe7cc81beea1a2357aa94122467b2e1ba222c91d58281464e025e2c5b"
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
