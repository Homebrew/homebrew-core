class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.84.2.tar.gz"
  sha256 "e9f27fd17d2b67a66d44a64b23f4395fb968bd8f5130df92177ee611770c4b68"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7969112d68d02258cc332862587a5ae2531b507ef86f2b1616575e6c82978a56"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "638af3a8db248ebc28be7dd863ce9fc35ee56f92fb83182be2feb6a1a7904e61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20ece72d60f0a28fcd0bcceb8b6b755ed8122093d06102d96ad2a52e9cc762d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed0879d1c07030326319369b17f0e4b9d0c6efb34ba82b86758862c94fdc32a2"
    sha256 cellar: :any_skip_relocation, ventura:        "f03773122765bedf0b57e523dc00cbe340fd24c2749f6fc23dc4b5e85cab1009"
    sha256 cellar: :any_skip_relocation, monterey:       "2574ece1e7d7f58e6ebad3a05574326955cbf32efda9a40249685c35b6160958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7855d7d9ffbc61b13bf1afd48dc1feb2b208f496da62c7f213cf538f714e3694"
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
