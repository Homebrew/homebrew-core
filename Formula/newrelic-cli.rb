class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.44.10.tar.gz"
  sha256 "44db041cc1c36949f4be3b5b7b118839a5a5de42fbbde184f6f6afd65b9067e0"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c370a7ce259d115fd6e4a3e03b492f97935acc251a4ca5eb3cd4bd87fddb1a8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7086ff324f9f7924c5b87ed00193774abfcc1e67e049d89bde35f2ca97cac3b5"
    sha256 cellar: :any_skip_relocation, monterey:       "a40fe6061f1d835f6c97fc1d584f25dd724ccf66500868ec049415d71be69b91"
    sha256 cellar: :any_skip_relocation, big_sur:        "5500327e3a6ae3c6fb3f0da73f3099d8257a7507f2a267fe1bd537fdc5fa8cfa"
    sha256 cellar: :any_skip_relocation, catalina:       "f728ce5fa561e86e58407cfa93e329d24d9b1b9d3b9706cf4731df9afe39098e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20b27f02e31815dc903af10392206b4d7251fe4a5b842683ce223c82f4e51138"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "fish")
    (fish_completion/"newrelic.fish").write output
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
