class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.36.29.tar.gz"
  sha256 "5129d5a61c2f92085967fd79cda0cd1ee54ac78b953c82d9671cde26a6c735d1"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ff165b8e9c0744667dedf614f0b79de1114f7a09047e196c380ca3388b6e0b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "974d412cdcb388eb5720b6691baf4c30f59e38827228824668c8a936a1d01c71"
    sha256 cellar: :any_skip_relocation, monterey:       "5cca74420fd982902abee6f6c9a5f53f60871bbb606616a39f940b568660b22a"
    sha256 cellar: :any_skip_relocation, big_sur:        "01874d6303d4ad38ad4670f9be0e6c55d6a881f7ed2e05bbd17203b475fa3dc0"
    sha256 cellar: :any_skip_relocation, catalina:       "2d78e29e9a95d486d734a5090680bef8ef1659ae7bdfe803d27d8be35deba12f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de315a57e8060a958ca485110e9752d12da61a1c9b760d649cc78c9b09c5436f"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

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
