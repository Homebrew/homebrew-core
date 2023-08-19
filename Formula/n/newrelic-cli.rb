class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.69.0.tar.gz"
  sha256 "6dfed6446ecb021cbf1daca3ddb1b94c95729118447d679e22c239ea86c0e7b2"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3382de2b467f30d6af8d10859ffaa293b7b67dff51318a4cfece0d09dbcbfab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fdd6b91a7a0a7d99f3ef99462e9072010b6b73848d1af01cda7a626f899acaa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b9466a47a9a634f85dcc8c87738eeb2eaf407192f9d5fc0855c34433bff8bc3"
    sha256 cellar: :any_skip_relocation, ventura:        "c54c040dee035f12980c786fff610d7fc180a19b96af25f68a43b7672528fc99"
    sha256 cellar: :any_skip_relocation, monterey:       "b8aa3b8d6327e8bb4f79a0ddbe3f9e3989e006c79ec12d74f8b8267b2d2c5279"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf462145dfd927f28516221aa7ff28fbcf494900dd1800653e04624ef35963cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f57a2d8cb603ea3d3c229a9f6ad935aca4bc5d8d1d6e15f6cadd68123d3274c3"
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
