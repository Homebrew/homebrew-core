class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.52.5.tar.gz"
  sha256 "287ea2c595e9d164b3864da8afe3010f200df574cc7d82daa59bc82cf81b3feb"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f60c0c2b2e8cba90c2e44cd37065f49bb98c6d8c6113697e344f531dda1cb3e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9542e4a505acf7a700a290bd7a5a216f1c5d9d3034930c980ddcee56a856ebc9"
    sha256 cellar: :any_skip_relocation, monterey:       "1f1fc291d354deb2a0864e9978285b7d8c090f9e22d11a433ba57f2aca6bc61e"
    sha256 cellar: :any_skip_relocation, big_sur:        "53cf615cce53dc55414917010f678dfce173a6e0ccb0f018204009f2f3934cb8"
    sha256 cellar: :any_skip_relocation, catalina:       "69d61fae1cc6fca583f870cd272fbca2e714202a5b4be1a9bea323ac0942550b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eeee93353d134740dba5f7e59f4318932394aa27015fcdfe94a7a1eaa842f87"
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
