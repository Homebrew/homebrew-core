class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.41.17.tar.gz"
  sha256 "fa8745723385a3db543c04bddd546a62c382778a9d1364171ee407c4434c87d2"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "537a2d0ee6626e1697f4bd6f0dd74bedb78087188a0cbb0bf7999c58b1befddf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8d47f675fc1258d985961070be587e72cb64bdecf98548d7c30cec71f17f89b"
    sha256 cellar: :any_skip_relocation, monterey:       "ba9d37f22d9c92e15827c48c549995bf180d1c703ffa6f9025017973d7fc3308"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b1f17128dfd90f5168a4e6fc40cbbf7ddd84548a429727a7c0b550efe46b0ef"
    sha256 cellar: :any_skip_relocation, catalina:       "b89ac9b4b00b76269b0407f20f3313015c84c0f64b5755b935129c7e73c7c4da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b079b97441c688901115324a5429da898ea23d19a20a436efe2690590a4dd1d8"
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
