class ArcaneCli < Formula
  desc "Command-line client for the Arcane Docker management platform"
  homepage "https://getarcane.app"
  url "https://github.com/getarcaneapp/arcane/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "81ee9fc24ab86bbabbfa04e8a9f388c9e8e31ad3de4a2b122126ee4c7704f6d9"
  license "BSD-3-Clause"
  head "https://github.com/getarcaneapp/arcane.git", branch: "main"

  bottle do
    manifest_sha256 "5e9ef8877f19f24a1543d7c7be4eca8e29372b8fdeff12bfa5d0b4521bdea4d8"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b43d34cb2b382c0ae9308ac9c580ac7e80f747826cb0a6ef4859f85d3786daca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b43d34cb2b382c0ae9308ac9c580ac7e80f747826cb0a6ef4859f85d3786daca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b43d34cb2b382c0ae9308ac9c580ac7e80f747826cb0a6ef4859f85d3786daca"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "acfe2c97b47739dbbfe4f7bae150f4d693e30561e73322c4a344f09be1795d8b"
    sha256 cellar: :any,                 x86_64_linux:      "aa1a77de2246984fbcad63d3b1602839c61fbd165799dd61400d8e78cbd53c9f"
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
