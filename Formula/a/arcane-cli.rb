class ArcaneCli < Formula
  desc "Command-line client for the Arcane Docker management platform"
  homepage "https://getarcane.app"
  url "https://github.com/getarcaneapp/arcane/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "437f66a6008a2a867d1f5fe077b6eed3e969d8ddc4e8ee15db91714258e058d6"
  license "BSD-3-Clause"
  head "https://github.com/getarcaneapp/arcane.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "45b8fbe243096151e925e5a310d0fa7a85217344ece352b5146014a173ed8723"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "45b8fbe243096151e925e5a310d0fa7a85217344ece352b5146014a173ed8723"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "45b8fbe243096151e925e5a310d0fa7a85217344ece352b5146014a173ed8723"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8f87474acc1eb0f1898305bda906e420ed371052e6f2815720e4acf6c47c4d76"
    sha256 cellar: :any,                 x86_64_linux:      "c491f8a186f89e2928995809d8d32f39d6e41af5e86a9c5b71d0570dd1c183f6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    # The top-level go.work also pulls in the backend's dependencies
    ENV["GOWORK"] = "off"
    system "go", "mod", "download", "-C", "cli"
  end

  def install
    ENV["GOWORK"] = "off"

    # Homebrew manages upgrades, so drop the self-update command
    inreplace "cli/pkg/root.go" do |s|
      s.gsub! "\t\"getarcane.dev/cli/v3/pkg/selfupdate\"\n", ""
      s.gsub! "selfupdate.Command(), ", ""
    end

    cd "cli" do
      ldflags = %W[
        -X getarcane.dev/cli/v3/internal/config.Version=#{version}
        -X getarcane.dev/cli/v3/internal/config.Revision=#{tap.user}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
    generate_completions_from_executable(bin/"arcane-cli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arcane-cli --version")

    config = testpath/"arcanecli.yml"
    system bin/"arcane-cli", "--config", config, "config", "init"
    system bin/"arcane-cli", "--config", config, "config", "set", "server-url", "http://127.0.0.1:3552"
    assert_match "server_url: http://127.0.0.1:3552", config.read

    output = shell_output("#{bin}/arcane-cli --config #{config} version 2>&1")
    assert_match "authentication is not configured", output

    assert_match(/^ARCANE_ENCRYPTION_KEY=\h{64}$/, shell_output("#{bin}/arcane-cli generate secret --format hex"))
  end
end
