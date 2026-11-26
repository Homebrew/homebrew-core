class AgentDeck < Formula
  desc "Terminal command center for AI coding agents"
  homepage "https://github.com/asheshgoplani/agent-deck"
  url "https://github.com/asheshgoplani/agent-deck/archive/refs/tags/v1.16.40.tar.gz"
  sha256 "31520fdfa6752a2835bbff0e965d9c1458bf523d7492d7815d6f974f40149bc0"
  license "MIT"
  head "https://github.com/asheshgoplani/agent-deck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "b4539f92fb8a543adf3bae140bc319cc4058903a287f60df8109fc64266feef6"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e0762167fcb2dd368980f8995118f015b8c809e6880e0eba8906f6dcce88a225"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e0762167fcb2dd368980f8995118f015b8c809e6880e0eba8906f6dcce88a225"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e0762167fcb2dd368980f8995118f015b8c809e6880e0eba8906f6dcce88a225"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ef2861c7fba3b48428cc9339a63c19f40e0e6bb6434c4ae08ddf24afb249ad9b"
    sha256 cellar: :any,                 x86_64_linux:      "5bbe1d8475322e8dcd09acf48265193f5bbfb35ce4dac0e0081f28fc727e6d01"
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
