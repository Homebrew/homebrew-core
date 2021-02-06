class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.18.22.tar.gz"
  sha256 "672a962d11a30301e9e3df072106c0423037b553b349bf32678f8916e5a032bd"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "74dc19f6eca12e4336fafb8eee00b264871bd05a83cec8638a11a03e270430b6"
    sha256 cellar: :any_skip_relocation, big_sur:       "677c34b5151eecd14c1f2f696d3c190615fc8c02a4cfb749ad0944bf07d891a8"
    sha256 cellar: :any_skip_relocation, catalina:      "1dc8de419ff3fa22b84bda90f269831861f562d752a4695bf85cc39911cf570b"
    sha256 cellar: :any_skip_relocation, mojave:        "070ed9a6f8a71dd02a7ccd16b90545e86271772389d383c924fa223907ef77bc"
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
