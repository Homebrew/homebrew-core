class ArcaneCli < Formula
  desc "Command-line client for the Arcane Docker management platform"
  homepage "https://getarcane.app"
  url "https://github.com/getarcaneapp/arcane/archive/refs/tags/v2.17.3.tar.gz"
  sha256 "03c2d51bc4db6e512612dd39220f0a7003cffff2c6b151cb4f1fe633d5f24c5a"
  license "BSD-3-Clause"
  head "https://github.com/getarcaneapp/arcane.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "84f12adb3542c032a8dc1e01924908713457530f2a0078e11d1ee485ccf116ee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e219e908a1946bed44b6ae191427bdaf07f47fe1c1b39f7382ad23cd37fee144"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0b0670b69c96d1e755bcd4e42b3b1c28f43c4066b5dc73ee9d8745dcbee0f498"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "92df4c85701e172ea1ef6e3e0185e0ae29347ba60279f5850992e9380a429af5"
    sha256 cellar: :any,                 x86_64_linux:      "7991881585a8efc121c3732d01c2c39fe60c5577a9427727f571cef42ffe7d5d"
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
