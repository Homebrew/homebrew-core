class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.115.9.tar.gz"
  sha256 "f693241af761f27c1b4fb3018f091a24f83dad9afce654d8ca88362d60a13e81"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ef9b00b957267e37acd18e563779b822a55bb912fb13d20a7f3698058907b2ad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "85dd4b62e80f46cfafe9723e514769c4d91e2e6cb30a34282b5f74aea2567dec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "29a908ddda6f10ae88911c1e0dc0f7c8003b9977f4b1f1e3975e7b8362110ab8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6b4c940aef7ae2e1c0d760b53e847e7fe8db61c1043fd36f8cbb49ef99ec140f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fb2e4de56f609b4c515698e394339d1e1e12e7704b7582e4faecf38695badcbe"
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
