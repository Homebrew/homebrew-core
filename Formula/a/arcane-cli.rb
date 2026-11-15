class ArcaneCli < Formula
  desc "Command-line client for the Arcane Docker management platform"
  homepage "https://getarcane.app"
  url "https://github.com/getarcaneapp/arcane/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "0766dd76b3d2f5d31fc1991c2684cac3810cdb169c74f09d64e4766c8b0ed409"
  license "BSD-3-Clause"
  head "https://github.com/getarcaneapp/arcane.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "37dfbf375786e64457995ecb0671d76d9799b891feee042a1e9088120fa1760d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "37dfbf375786e64457995ecb0671d76d9799b891feee042a1e9088120fa1760d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "37dfbf375786e64457995ecb0671d76d9799b891feee042a1e9088120fa1760d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f3d2855f7ecf44c57b0c0fafaf2eb0183df071718d998395e2c75d89122b3e31"
    sha256 cellar: :any,                 x86_64_linux:      "2e4664a2ee59c54569b5d3c83e581b0410d390030809c09f35a609c940761ca4"
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
