class ArcaneCli < Formula
  desc "Command-line client for the Arcane Docker management platform"
  homepage "https://getarcane.app"
  url "https://github.com/getarcaneapp/arcane/archive/refs/tags/v2.16.1.tar.gz"
  sha256 "6dc7313e10acef004c9bc8e01bcb566cc4decdd4dbb26413422e922db13b5459"
  license "BSD-3-Clause"
  head "https://github.com/getarcaneapp/arcane.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5b92a928eb975ae79c56842f64cca9db69ee20d9aeb73458692193e41e83ca56"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "44736eeab67751c456d9d8db1fbb357713c4b2527aa048c8db89242c081b106e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "598d5b94fbca6a9ac03a3a1bbbe48919fca53f40ebca45b0c3cd383c6303995c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8f0e1ad330b302ca29f41c76cb0772b0ee96da5a73558388381ccb4d5a167bb7"
    sha256 cellar: :any,                 x86_64_linux:      "555025917fe511cb6fa024a0c9324f69e0111fe650690c5a5436dd461d18777a"
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
