class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.116.3.tar.gz"
  sha256 "8fb0e605fefbe6c7f91451ccc17575b593cc9c90c67e19b9dc86b0915e45a43a"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eec76f95fc04afa8c606f51d05493768bc1d3c91e34677675b5289550b3e7b38"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "64ff14d1d36b0e31edfbe80c06dbc10f88f6410b40f2de794dc102b2a1f2f606"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "afadba2f664a338d937d60c484a614d45e7c4d69c2468ecab0e48f26c5d092ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b00b1a14d1720ce0193dff5174e2fe8138ab51c54ea02eab26d5c93c80751896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f36d31c9fd3c9db22bd99ce5dc8631a93fb84ace6d5a7b5e9f859b272a08660c"
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
