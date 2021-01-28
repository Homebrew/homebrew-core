class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.18.20.tar.gz"
  sha256 "a82d39587e9c279b6382de66079c672ad33b8ffb89d68cb1828eff19f066b1d0"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c8a13ccd4b3a240438743b0a61af7aab4e331d92fee79077082c044567a10d4d" => :big_sur
    sha256 "bb73a2a8e7347597a4fd16943a90f3b753ebefb057d7ce1f3d2c9b0dfa8e8a04" => :arm64_big_sur
    sha256 "5bab129e2472c61373820c6b794649d4d275c6f6e32990817059d42fa9f399a2" => :catalina
    sha256 "05318a1e99b1e02d3d04bdc26463b54a9da16fcd72165081ee660633b7e538c0" => :mojave
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
