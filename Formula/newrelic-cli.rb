class NewrelicCli < Formula
  desc "The New Relic Command-line Interface"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.4.0.tar.gz"
  sha256 "de39cd4cb368cb06002b6702bab85efdf85cee1991b606213cdb80029d2ae208"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "82a93147218d56be1a074cf78a143640449dde11b810a95d72f6ec9fb1ab5825" => :catalina
    sha256 "37a18780f6ad9aa01560dbfefd2607a044ea88b63ca20ceb92caf5af7fa0b5ee" => :mojave
    sha256 "fa1b2f8f2a43026355d2f4d462cc24e1ed3a74b582f0c5b9414af60cf16d1914" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/darwin/newrelic"
  end

  test do
    assert_match /pluginDir/, shell_output("#{bin}/newrelic config list")
    assert_match /logLevel/, shell_output("#{bin}/newrelic config list")
    assert_match /sendUsageData/, shell_output("#{bin}/newrelic config list")
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
