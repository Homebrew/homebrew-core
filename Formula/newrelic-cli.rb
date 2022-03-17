class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.44.0.tar.gz"
  sha256 "99c5b7b4c7b8fe68b8b81723b83871a063c6b21ff10f0270d5bab07b68b2be36"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1d187dee4f433b2f35ea5b568ad777262cdd1d52aa6d192e746ce6b9d62b212"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98cdc06f8216e7084b443e24bb79bb7a4b5d1ffc9e73f86c5d9d1440de1327a6"
    sha256 cellar: :any_skip_relocation, monterey:       "3ce6a9c7397f1fe6447091b592da9e2449a3948098c51c79af7a1d44a22e164e"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e5f4ead1297c39fef6dd0b1c218f4c74392fc8e9d1f376191fd562598808a73"
    sha256 cellar: :any_skip_relocation, catalina:       "f697f167a46cc002212d54fd4bbf883b05ada73d6eb80222dca1114766e1a338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fb2445779c11419dde9301275685b9deddb2ff792782a5dbc3466c006bd0152"
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
