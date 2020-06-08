class NewrelicCli < Formula
  desc "The New Relic Command-line Interface"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.8.5.tar.gz"
  sha256 "40692878953eb3ed43e4652d757985167fdd3bdd1b5916507e4f5327fceeeecd"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "13a086040435e1d250df038c84991117f67524410a4b8f5ebf9989e771ccfa7f" => :catalina
    sha256 "059521039bc761ac99544b8035c6879016202523433fa4ddfabd8e6cb80df004" => :mojave
    sha256 "239dd344fcdc8d80f29dfa2633b7fb39f4adf9f24abac2d216bbf85161c64c11" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/darwin/newrelic"

    output = Utils.safe_popen_read("#{bin}/newrelic completion --shell bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read("#{bin}/newrelic completion --shell zsh")
    (zsh_completion/"_newrelic").write output
  end

  test do
    assert_match /pluginDir/, shell_output("#{bin}/newrelic config list")
    assert_match /logLevel/, shell_output("#{bin}/newrelic config list")
    assert_match /sendUsageData/, shell_output("#{bin}/newrelic config list")
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
