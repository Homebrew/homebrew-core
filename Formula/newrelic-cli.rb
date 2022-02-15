class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.41.22.tar.gz"
  sha256 "3a8fbf3d4f4e0a09782f909b001d758744719f59795c4abf0bfe232ff48428ae"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12b91ba1a4a000b872c6dd0778a1be8936114cc51c4a65c99600ed37a775a337"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "befc16005363a4608907a61570d270ad4edfae7a92dec9f0390fe5f6f05cad61"
    sha256 cellar: :any_skip_relocation, monterey:       "7e86af4023650714e9a277cca80eac906b1e47baa1c84b7385c60b3c9a375c2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a240525cc39182290cac1699ec67ae7eadf826be7e390844d9f69d6d6e186f1"
    sha256 cellar: :any_skip_relocation, catalina:       "fc777c91f05999ee765eb4da6ece93ba364292bf3a188522f27d1e54aeab6677"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa61eb3cf35e5cf433538b568432178c123c8be954a0b0a7f0421e47bf73a15b"
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
