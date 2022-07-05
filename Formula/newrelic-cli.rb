class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.51.3.tar.gz"
  sha256 "30c27cbf2030aca8a46e703d4ab6b2c7a488e731b2eb1e0b219a06b350c79c36"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "176bfe1e299b9d429d3da013adbf029aac32da3d5a3cb1ed37441dadd752beb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ffa3636b05b446cb0f17810d81aeec025351064fc656971c27cb02cecb42715"
    sha256 cellar: :any_skip_relocation, monterey:       "274711e6821af9358096479aad9ba8bb5eaf6ac6740232070ac5be09bcb34792"
    sha256 cellar: :any_skip_relocation, big_sur:        "d65bd1fe49423d824b3bc5351ef66bb0068803404fa35e8e9b74fc29b8ddf98d"
    sha256 cellar: :any_skip_relocation, catalina:       "eba1afb70fda270633bc31234c023c0370184d3a6b716e60de7911c497d55d1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73e13e44be1aba5b467ad5048e4d8da9d8dddf0b6e9b660e5de3df2237407f99"
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
