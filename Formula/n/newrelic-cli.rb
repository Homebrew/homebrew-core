class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.115.11.tar.gz"
  sha256 "f0560c6c82165db43d0ec825a5d15d4bdc8d7fab54de8209189dde3216b42f82"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "91f485c058befcd591aebbe1c081317aa37d5cafafcfd4ac5638646502d4c1cc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "076179a118818ce969f9663ac6b1a95ed12c645267ec36ef3c089f6e2348163c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "901d9db2c58a6450a7adedfcb2036e9a0294c53c684b9a19b979d4826c524f05"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bd07b70784680307545f5240ad0f5d085903a3020136bf1c9b9bbcf01f9b1bcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b29b85e37339916f490cba094a7b718e99bd19ddba53b9993bdfcb1190658ff3"
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
