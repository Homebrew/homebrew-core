class AgentDeck < Formula
  desc "Terminal command center for AI coding agents"
  homepage "https://github.com/asheshgoplani/agent-deck"
  url "https://github.com/asheshgoplani/agent-deck/archive/refs/tags/v1.16.41.tar.gz"
  sha256 "7fce719010da0a691b2167b562db5f8d24f83da0b8dab8c1080450093feb1ce7"
  license "MIT"
  head "https://github.com/asheshgoplani/agent-deck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "c8fbc310b608e91df8c3adfce2395b90b78424ab89f9808b4b8a0fefb3a33a25"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "44e223a9b24e93852579d30b498737c5059cfb181c74cddcd1456b1e4bae4c6e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "44e223a9b24e93852579d30b498737c5059cfb181c74cddcd1456b1e4bae4c6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "44e223a9b24e93852579d30b498737c5059cfb181c74cddcd1456b1e4bae4c6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a8db47ba9e9fcdc4f395fcff5adba720411fd068541a51cdf4090452155401c9"
    sha256 cellar: :any,                 x86_64_linux:      "dfdca782f32b3963c532f6713c0cd278d711124173b842fa5b6cea1c425a362e"
  end

  depends_on "go" => :build
  depends_on "tmux"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/agent-deck"
    generate_completions_from_executable(bin/"agent-deck", "completion")
  end

  service do
    run [opt_bin/"agent-deck", "web", "--no-tui", "--listen", "127.0.0.1:8420"]
    log_path var/"log/agent-deck.log"
    error_log_path var/"log/agent-deck.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agent-deck --version")

    system bin/"agent-deck", "profile", "create", "homebrew-test"
    assert_match "homebrew-test", shell_output("#{bin}/agent-deck profile list")
  end
end
