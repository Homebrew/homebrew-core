class ArcaneCli < Formula
  desc "Command-line client for the Arcane Docker management platform"
  homepage "https://getarcane.app"
  url "https://github.com/getarcaneapp/arcane/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "0766dd76b3d2f5d31fc1991c2684cac3810cdb169c74f09d64e4766c8b0ed409"
  license "BSD-3-Clause"
  head "https://github.com/getarcaneapp/arcane.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2bdee727d8993213ca3bde6460b74c1cc0a2a2d773947a8e26b7dd5968e60ece"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2bdee727d8993213ca3bde6460b74c1cc0a2a2d773947a8e26b7dd5968e60ece"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2bdee727d8993213ca3bde6460b74c1cc0a2a2d773947a8e26b7dd5968e60ece"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6b315783419d833f7e1dae868e9b784798b89d188b32f7546d03220394495ec8"
    sha256 cellar: :any,                 x86_64_linux:      "eb5d8e8954bd9df96237ed4e19dc639b8fd19c986d48bde9166505dd5eb9c346"
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
