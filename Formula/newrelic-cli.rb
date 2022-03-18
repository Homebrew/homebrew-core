class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.44.2.tar.gz"
  sha256 "db36badf98ac69e27b441ff871ca644a64a4aee8d37832380473166b5b68d8a3"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15e4145f5621fab8a8bfa46899f51fb6104cf9fd66e84a83ad65f5e9461dd726"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22f6caa7a74d57af89f6dfc66bdc9f2a45f88201b6dbc7b34ad2c3305993bdaf"
    sha256 cellar: :any_skip_relocation, monterey:       "53c4b26e37422abbe93cd71f93f54f48fcdf79faea65486e9da7c3be431221d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "93aa5085678d59c7e4c9c50885610875a9f3fb7e235be262678f89a3726c39af"
    sha256 cellar: :any_skip_relocation, catalina:       "0d11612287f99ea46704cc82c75267d6b87a71981639647485627af1622d6f4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcb23fa8ed2f9a6dd26211130411774b64a38de584f115bb54dac5565cdc06b1"
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
