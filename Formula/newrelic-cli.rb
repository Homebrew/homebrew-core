class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.37.13.tar.gz"
  sha256 "f897ed37ea32998d2fba603903311d0caa76fc835bef62739ab122863fb28dfd"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c00f28896e8f852c78993545aa92d973eb5065570784bd69618a6481f8a915c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "663173263994fe7cfd68f5668a5fec5530ee9d029eee13d9034b0e95f883a1cd"
    sha256 cellar: :any_skip_relocation, monterey:       "700d87cc36354a6411f8e26f2a1b367cfac84dab39531e362e61ee5fe5f462ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "60cb59e9ad4b9c855376598667b01cccd8c0bb07ecbec06f53d38435689ce50d"
    sha256 cellar: :any_skip_relocation, catalina:       "97183b2ae7b6f4983d2e65cd13be3ec48191487645c935b8691495784ee946ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa3f600821bb582fbd06be0a5fb50620ce86ceb0cba1e51f0c812bbfe0df13dd"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
