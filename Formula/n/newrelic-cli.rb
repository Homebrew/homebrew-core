class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.115.10.tar.gz"
  sha256 "614aa842cfe3d02468ebb0ea53a758c8a456760c4fba961047822181f538914f"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c6903c29971dc9fb6cc28698f4506c7e6c321cbff2f1f590077671bcf327cdaa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4cd558f6f44bf96aef2c977a36f43b3cb52b6161d9e1ba515e26e89041a9e4f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c643554cc39b035f07877dc6dcf7b1005a007d3afac0e4466e370b400e6943fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "278dbbb478c9c9320df085ee55ecc6486f0e5e69c97202b1f8a0f551ed4cc3d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ceca177221965fc53c8d8c86803a063398246bfc60ee64bf0fe86b384e0549cd"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
