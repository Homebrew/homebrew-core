class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "5bf6bb004e584a36ac9e44449d71c5853f859b01ef7b2eb55c326afa30de7de1"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "1a56152c75e5798843fda4ae4d4c291ef3efbdf14cec90172066040a8a8fbe14"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8f41ee0d53b5df837df2f91d90929469266725ad4aeee663f590b18ba90510d4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a330f0bec2b1a0ae19b8464c0567401692856340345932e985a1633a3e953aa5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8b34e0aa0644496124e65ad97cfd4e83dfee3c69bdce36188961114717ae2a3f"
    sha256 cellar: :any,                 arm64_linux:       "856891eb5ffd75f70f2eda3c89a8e4f019279714a2a1569f51efe5b9d1d43603"
    sha256 cellar: :any,                 x86_64_linux:      "a2dbf0a172fcc95d1ce0b46069a3aece7acc6d2a2a4c7e02726e1d2f33daab24"
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
