class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.56.1.tar.gz"
  sha256 "f219a0dc4d189fa53ce10a471898c55a71c6be475bb68c2d4315d3738f20bac9"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0dc93b12c5d15f0b61f2ce40ca53d1be3b7395d7a452e00c8e0f9935eafbcb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7c106c2aa35e2fc44614c3e918ddd7c608e12b106c969d12e1e8e2ceb77ab2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8af45ff8c8f05ced01dd4e119fafa7fbc51cf9519e04c7305c552256252bd1c5"
    sha256 cellar: :any_skip_relocation, monterey:       "845c33846725683dd263d95777540f5e3aaf71bb25f40b4783314d324fc566c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3754666ae5d5c4ba1c6a6ee46657ff6e4628ef5d167bea30a668360ad0f1f7c6"
    sha256 cellar: :any_skip_relocation, catalina:       "c7a1e4433afab270373bf92ec645eb183647b647b9e0691e5a1c564d24dac5f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e4db6752b40f1b21671cae224f69acccc342d5e3c1636fd9f5a4da6303f2c40"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
