class NewrelicCli < Formula
  desc "The New Relic Command-line Interface"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.8.4.tar.gz"
  sha256 "748dcafb7da3a2296514c138212e816b867a4c580b96e4f32c5dff7913cb4ab7"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f377056a9093557bbbcf996b6c7a57deabe2c6bf35d11936e10750b4d90dc819" => :catalina
    sha256 "6927eefa17e844afbd96ff94d27c7e5cd2592ab8bda523f9a2da3ada20d15c77" => :mojave
    sha256 "011b856a1ccccb208f04186014a24cd6ac25f45ebc752d04a7ddd27ca2b0a7f7" => :high_sierra
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
