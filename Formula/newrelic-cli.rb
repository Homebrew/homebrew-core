class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.50.1.tar.gz"
  sha256 "93065c600ea6fa9d980e7e24d264831e2539ae16295b03009f05370f524d70d3"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d972cd4bb39ba39c67b057774b67a915b43ad8857e7efb23a7cb680ec8e6e825"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c6e39cb789c1114ec7bd98e414ade65dca7a5b28f5bbb98173f9e8bfe551a5a"
    sha256 cellar: :any_skip_relocation, monterey:       "107c53a0eea9a47e91fd4643a0aa84782cb0928021a82e4a5c88e56b5c2b401e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b36eff49a0e4936b5fea8950a5429399c604fe8bdbec713b1b90ce18f297795"
    sha256 cellar: :any_skip_relocation, catalina:       "371b772beea0fc1e6ced4f931cb88dadd736b9ecdb2272d34aa75f5ce21f4175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daf35b54ccf530cdae209d0152441aa88acd33bda0225ab271ad8037a2907c48"
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
