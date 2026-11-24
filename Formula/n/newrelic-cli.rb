class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.117.1.tar.gz"
  sha256 "c0e50831fe301a8d4f6b5e398dbb018e2fe79f720df870eef8313615dce6f0ae"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "5d1732b1c9da5172059162ccfc1a2e800d47a042dbd6b1db3dcef61b56d04991"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b14151802814dc745a189b2aeb295af75c4176cb7c2a0dc64c20eaa3423be903"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0fa87970796dde1fbaffa35f2f5c255cb89ea4c2f59100ce17a0f807e38a754d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c3bb8d648c0d0d5c4ff10a8e8f28f51030a2f5937e2e8a477232b3335c1610cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "addcd14afe6b6212efb4d8bcac2c33aa3c6334a897162bc9f5f96e35e9adf676"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "74e4b7013f48e7edd070bab720517319af3b7674bae056a7f83eb19e684bfe1a"
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
