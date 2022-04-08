class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.44.10.tar.gz"
  sha256 "44db041cc1c36949f4be3b5b7b118839a5a5de42fbbde184f6f6afd65b9067e0"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0082d95d8cdf0e08cad80b3f2630d42c73402791d680f13839281efd3cd610d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44f7a26747f1c514ff56c29813a38506e7b124667952d0fc8ac909d1e87af63a"
    sha256 cellar: :any_skip_relocation, monterey:       "9c0bac22111292b60033229458df8e0d7200ff392e23d7ff463da156092f9ab3"
    sha256 cellar: :any_skip_relocation, big_sur:        "666443a26309a055dfd21868fc7adef970b9eb31b858e27835efe14db10fd304"
    sha256 cellar: :any_skip_relocation, catalina:       "18c535deedb767738ee8cb0a458aa00ae1f011394448c9765b2bd30822a9755d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baa9dc94c4973300a7f73358466ddfa898905e763adc1fedb7898cc9d791cccc"
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
