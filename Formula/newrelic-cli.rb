class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.68.14.tar.gz"
  sha256 "6d3ad6c6d244508dda87828eb5ad8b5cb1909ac1b2520a08a592f8437901da36"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b764eb9ac2a1f5c303f5e0137d1f38bd2200799516cf338c88fb2de7d77640a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d7ae968b742cc05b74d7e06ec58f1f0fca1353ce5652eda2a326e91139bc0c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37e802e70228f12f1107ef32d51920725049795766e28943ad7940aa8e251e8a"
    sha256 cellar: :any_skip_relocation, ventura:        "4030883c981d8e58ff0c908818b2e230a2be92a583ef8bc507ee899bc49f9775"
    sha256 cellar: :any_skip_relocation, monterey:       "cc73dae70816fdebf6206944dab797bdfca961b67def4bdf7ac6cc7834225d21"
    sha256 cellar: :any_skip_relocation, big_sur:        "cec2a27430b17276e0241ea824ffea59bfe8c743ec07cbda4114dc8a451a11ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38d3ad555aa05058ce0d24979f8e1414eed75808c72211947281f216898af7d6"
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
