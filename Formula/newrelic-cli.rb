class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.50.13.tar.gz"
  sha256 "c9c47edd680428b60090d88b951fb8bd16f71e6ed121877c153e9d74e6089f4b"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cb590de98d4a184c7ddca1a223b4a003ea0c7c802522cf84a131256cdbf1141"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c393bf41281026cdfb08ee194cd92878353cc2192787f8771dbcc175043d1454"
    sha256 cellar: :any_skip_relocation, monterey:       "1141ef1b9cb715fa18c435c23f933a2078ef1846c5209e3af489201526855016"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c3f2ac57179283af8d2891d8341bdba09853f80d6aa1e04f6fee317289acb68"
    sha256 cellar: :any_skip_relocation, catalina:       "e3bd6b3b6f8a995fd8d1bb2076ba9ca20bc02cf3b3b54742e3220427de2e7b35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec196b6f29dcf14f443f21a7785772cc4738abc6daa0a98a83867a47e8916e41"
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
