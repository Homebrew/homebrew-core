class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.41.18.tar.gz"
  sha256 "139dda1cc677ff1a88bc5f8dfdb779d55f66d6fe99a8136f95db3563c695122f"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2536d97438f5539b943b2aabeb141ac8644cd13fba0293dfea39237f56bf69f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd2893a60c233f7806053f18df740824561a8816039f17d04d5d6dcea667f1fe"
    sha256 cellar: :any_skip_relocation, monterey:       "ee98a5f0c4cc7afbb94f4ac54e3bf3ad1f7283b26102557916599d83a34dee9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6b060b3e098f5fdbe49abd6ecca0545e9e506cff558d1fc541d9bf0461088b4"
    sha256 cellar: :any_skip_relocation, catalina:       "b1270489d552b1cdc1e987e3a0b8cd0e6ca7cf03b92eb19d6fdc83e11a037383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1893d3442b64448d7cdc96a3437e1405d7bb407afcde98dd732389b039883468"
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
