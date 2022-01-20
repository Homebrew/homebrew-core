class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.41.14.tar.gz"
  sha256 "834e5edab659c306427f8072da3e43af1937d01c4e27291c5d2cd88f2dee6cd3"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d10406a4054d2bbfd00c335aa68474dd32b97f56beba2e103c837918ff9abf40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6a65ebb1d5d2ef8503abd017d256a7175aae84fa9519899c1a671fd0c79e550"
    sha256 cellar: :any_skip_relocation, monterey:       "e6b46432c67ac868562feaa3a058ca8aadbaf44e426527125e61065486531f39"
    sha256 cellar: :any_skip_relocation, big_sur:        "26e84788201629bf3bb70a9e9ba0343274cc66436bf359e65b78f889ed95ec45"
    sha256 cellar: :any_skip_relocation, catalina:       "ac68a3ec4acf1f2c106fa31de5bb044e4441c020ff05c84b08305898a5b8f1cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c59c8121b9edda30b6ec064cc1d2a138ebbf720c5e9b91d8877731410d4b7d14"
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
