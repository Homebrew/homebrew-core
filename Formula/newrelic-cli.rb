class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.30.5.tar.gz"
  sha256 "3861ec99ecd8cecf93993fe6d1e4d573d2e615ccc930763cc7314ca23242bcca"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e495c87a3e4b8abdb51c4cabae685333ba1ccacae22974b599bb712158d332d6"
    sha256 cellar: :any_skip_relocation, big_sur:       "238ba99779abf1b8994364b7e9b6a8c90bd3db2451b5d30202ea93c37b23b1c5"
    sha256 cellar: :any_skip_relocation, catalina:      "4fd73dfe13c8263e0e0188001ca801076ac231506f3be740344fcb395b7cf397"
    sha256 cellar: :any_skip_relocation, mojave:        "571898d748c686e064f70df764f9df28d468709389437cdf3e9502c790a522cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ee3a4c2501b2bb52e9f4b953daeabefe43be24e17ea19a96ff9e9845cee5029"
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
