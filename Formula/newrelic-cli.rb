class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.18.1.tar.gz"
  sha256 "4fdaf042262770a2a9a00c9359e40592a447ad6c19de7b98f26b010ff7eca59c"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "787994bd9b3458584ed6023503692d8a807d821cdf5874646cd721277515259f" => :big_sur
    sha256 "195d32b60fe0f02ae9aeee7e6f16f3754e68e16c3aec3b81b8bfedef05b904c9" => :catalina
    sha256 "8b8c6e7754bcc2ccf7a394a10dd9cfec2da24be0f5c875d2c388edd6f8f97e57" => :mojave
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/darwin/newrelic"

    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
  end

  test do
    assert_match /pluginDir/, shell_output("#{bin}/newrelic config list")
    assert_match /logLevel/, shell_output("#{bin}/newrelic config list")
    assert_match /sendUsageData/, shell_output("#{bin}/newrelic config list")
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
