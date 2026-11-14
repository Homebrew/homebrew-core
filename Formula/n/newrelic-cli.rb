class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.116.0.tar.gz"
  sha256 "3aae7cb09d01236a2ae309aac7bf8a62576209cf424ac1518878fbb6559ec02e"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "05d9391e8440f89ab441e2fccfff582ad2f6d8da80018a3d8b7f7b1bfac62e98"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cafec119a77c6b904530478e61517bf03ffe00b097c06fa46bc7f7d1b290535e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b93a71641472759a7136895fd28e4f2e4d7f9145603d88f55aa98e228dc130df"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "512afcd80735e178a052aed13d8883282c8b882423eff2e6c0bc4e082626f713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "17e8f76ab047cd3f00ede51194c9ffc0870fba78e8631acf2addf014db2a2789"
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
