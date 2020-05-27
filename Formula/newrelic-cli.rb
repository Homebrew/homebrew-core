class NewrelicCli < Formula
  desc "The New Relic Command-line Interface"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.8.4.tar.gz"
  sha256 "748dcafb7da3a2296514c138212e816b867a4c580b96e4f32c5dff7913cb4ab7"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5fd90b93c61d4e839ba2bb8c48346300be1c7b0791219d16b64379e34fb4a31b" => :catalina
    sha256 "9f769b21a460f8135b0d2dafa28f8dec5443871630b58a6b4df9f504ec5639a9" => :mojave
    sha256 "aea1c4cfcc880346eac3473621bb655f03691834fca8bede4f05626b218a838c" => :high_sierra
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
