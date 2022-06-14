class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.50.4.tar.gz"
  sha256 "891ee12b8238c0629b6d9f6a088193569dc4c6ba9f8ed5e015f8897f960f8324"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0baad64f5df9ddd58fd1aa440fe171e8dd9fce9f35966aae86b34a6a743d5e33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79c83062f934da0097c115a4f6580a93caeb02f3888fe443b23b7c827d56bdda"
    sha256 cellar: :any_skip_relocation, monterey:       "bc82deb42c19e03896eeba8f2a418d08497ccf963f886c99133259737c067255"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f9bbaa6ed9d93a43c42eed20b751d4d4bb0b3cd11be85782ddde9b6867e6d23"
    sha256 cellar: :any_skip_relocation, catalina:       "04443403e7bdb2185a9a0064e31d3c3d198da3f57507c466f9a1003dfc604713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53fccb3d1635889b0da946468fce9e625885702b484eae14741db3e7d24fab80"
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
