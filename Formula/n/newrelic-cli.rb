class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.71.0.tar.gz"
  sha256 "ce1eba5ff4e0b51f6f68eb74d8153fd9fe4aaaade59c7b4e9f0c9556093fe116"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13ed71c0bab109e4f8abb1ecea077eb9b79f2c38790490f34abc6abb74bde4b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58b06c702f3c187c65ecd83066bc982b2f394c51efcbe443dc46317ae49c30bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8e60ffc554e4390cc9d55e4accc4c409783eb6062692cad0a48f75f34e4ed74"
    sha256 cellar: :any_skip_relocation, ventura:        "c7457202b68749c205812639b02f18a770c5d2197513caeea8fcf20f769b6c73"
    sha256 cellar: :any_skip_relocation, monterey:       "92afc9e32e6399db62d674bc538bc8b31a10e265557d2f5b53f77b2cbe304f10"
    sha256 cellar: :any_skip_relocation, big_sur:        "f75a1215b57273d3e90927892b89e449d3e6cc725baa4ed1e38a4d56b4e9a49f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f05e12da52a722f8ffc629863628666677f7a2d0770817e7484a76e435b3fc53"
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
