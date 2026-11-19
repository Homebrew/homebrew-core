class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.117.0.tar.gz"
  sha256 "8c5c23d5be832fb185813036b7b423e54a40c3065723d77f305a30709c5ce2c4"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4c49f22fbaca214846cc091e66eb39d5d449ff94fbe5d3bc6477a87716a0e31d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "03a6be6f0e95fce2c694d90ead96630fd817315f77c3dbe4f9ffcac0aaba9c3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3355ff8e33d9f562cb6447a701acdf05ca9ad27fdf4473e3a41c3c8cf6ed2e34"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "454b637934ec3cba9c9594f3b2956eda7ed639e54aeab87b92b5744747e9e73d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f218201ba3c37246ab383e1d49a897f1ce59feec753fb0bfdd9f18906dfee0d5"
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
