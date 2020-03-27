class NewrelicCli < Formula
  desc "The New Relic Command-line Interface"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.5.0.tar.gz"
  sha256 "11e99b789383d7a45d10c30766c9bebb84104b767290c1f80755737ea75b6a48"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8cec5f941f4debc4ee6aeb677a958aea0bb767779f15cabb5dd36644151353b5" => :catalina
    sha256 "d0190fc7cfb04544eb7e05125e4888b6226183f4777d5923b3afa45ca8803dfc" => :mojave
    sha256 "147be967461677898528c16b3561b30e1c5803d8cdddea47bbe9af8d6e667933" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/darwin/newrelic"

    output = Utils.popen_read("#{bin}/newrelic completion --shell bash")
    (bash_completion/"newrelic").write output
    output = Utils.popen_read("#{bin}/newrelic completion --shell zsh")
    (zsh_completion/"_newrelic").write output
  end

  test do
    assert_match /pluginDir/, shell_output("#{bin}/newrelic config list")
    assert_match /logLevel/, shell_output("#{bin}/newrelic config list")
    assert_match /sendUsageData/, shell_output("#{bin}/newrelic config list")
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
