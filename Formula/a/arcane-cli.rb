class ArcaneCli < Formula
  desc "Command-line client for the Arcane Docker management platform"
  homepage "https://getarcane.app"
  url "https://github.com/getarcaneapp/arcane/archive/refs/tags/v2.17.3.tar.gz"
  sha256 "03c2d51bc4db6e512612dd39220f0a7003cffff2c6b151cb4f1fe633d5f24c5a"
  license "BSD-3-Clause"
  head "https://github.com/getarcaneapp/arcane.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a568830cfbd9c5c1af7729ed516fd100e0fe35dd8fe364714a0f0fe8052f9cd7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "167529f36df648afdb6c2473a54927ce6bb6e43dda23bd23916d7fcb2d6efc22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "61b70617e529a4ea2aced3e6857e94ce0f21cd28178f52fda74568cf053b2d97"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8897142c80c221c90b1551e864324ccefc95add931fff3cc6b52a4003d8c246c"
    sha256 cellar: :any,                 x86_64_linux:      "38843841b0b23a9fd0c4243f398aed6088046ac8c3b31c33bb2a1546209ad464"
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
      s.gsub! "\t\"github.com/getarcaneapp/arcane/cli/v2/pkg/selfupdate\"\n", ""
      s.gsub! "selfupdate.Command(), ", ""
    end

    cd "cli" do
      ldflags = %W[
        -X github.com/getarcaneapp/arcane/cli/v2/internal/config.Version=#{version}
        -X github.com/getarcaneapp/arcane/cli/v2/internal/config.Revision=#{tap.user}
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

    assert_match(/^ENCRYPTION_KEY=\h{64}$/, shell_output("#{bin}/arcane-cli generate secret --format hex"))
  end
end
