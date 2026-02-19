class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.106.23.tar.gz"
  sha256 "4bd688db0ea95965897c57fbc60d4f819a5f0c1b7f372fdf078003ca0ec1f962"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "273fcbf4a2489901fe6aea377634d0201bd03fc7cf7bfd1fb1c041ee5744afa1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51d2c119f779a1f48fd3e6b3e5992e18c72c5a6d6976ae66a3571d81e1c45356"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "386821b34da0b6b64ac2cc1b2b913ea7f3b681a98f3fc8aed8ac144b2a95da08"
    sha256 cellar: :any_skip_relocation, sonoma:        "1add873416ef4f77609336e5bc2d8b0734748b6dbc66ed76097efa79dcc68e4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad3d0950934c90f278731ca06839d9fce6445db9be5db3061a1514bde47e865d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9435549598c3af1815981f5e63a3e892ec3790e5dde7c307d917490d61653c17"
  end

  depends_on "go" => :build

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
