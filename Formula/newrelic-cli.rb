class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.41.8.tar.gz"
  sha256 "59d9d412dfcfe832b1b5d51de432e5275c6ad448f1aaf419f9c9a9fcc54fff0f"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d781031b93ab04d97d75f26addd0791438c01eb219e02134e7db7920460c716a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e61ddbccc33eac914aa2f5541f170fe3470d844c86412a41022b96259e17c55"
    sha256 cellar: :any_skip_relocation, monterey:       "7db7ff3918d073fdcf71811479269b4bd716c91234b1971b365bbecc16bf70f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "8034dc4accdd82aa6973425bfd51c24db44814eed4902a7c97901aeaeec596ef"
    sha256 cellar: :any_skip_relocation, catalina:       "558c7748673d22e980fc6545348f7fbea9dfdf15d598da8e2d71c9a246824e17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "feceabad6fc2d86469b2d781646916e20868af958cc4e4f83ced16c1a1672f84"
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
