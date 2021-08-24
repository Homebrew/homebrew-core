class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.34.8.tar.gz"
  sha256 "b8d3d2ae818f5e43f1c4fe885361efcf9a909b6bea7984a153f25b7f4b47573a"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d2eb18da95957751086e6187c72eb6349d8f67021a04b371a5b1ecb9395c4bd6"
    sha256 cellar: :any_skip_relocation, big_sur:       "e7058135ff0751771e1383a3cb9532872d10a3f04ec23737932cbee74c7c46ce"
    sha256 cellar: :any_skip_relocation, catalina:      "d616d2806d8794ac6674e84c710907e6ed1382943838be9ee39bfe46be1b2749"
    sha256 cellar: :any_skip_relocation, mojave:        "b31e682124b2c86ff384ce4bf8ddfbdf64b6ea962600bba867a976a44f137b46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d4110eb612507832c535a981b299f3fe9da4ba18df1ca0ab6a5cf857075aac9"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    on_macos do
      bin.install "bin/darwin/newrelic"
    end
    on_linux do
      bin.install "bin/linux/newrelic"
    end

    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
