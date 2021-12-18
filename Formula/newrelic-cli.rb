class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.41.0.tar.gz"
  sha256 "c083a481aecb53d385fc14ccf68d8051e0ea3f79725d18a1eede63a18d8c6c48"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02c1f9b1c3d38b26306f5b50fcaddbf545add917252e81d72f97669130223523"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5cc80eb1e450c4f66e2e999f9e25d64f380ddcd699a3949ec6f89d3c55664f50"
    sha256 cellar: :any_skip_relocation, monterey:       "c30ba99d417f0cf14e84239273d066b153851bbc27f12f1463ebb0bda12750cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "961772972c17a943092a8c43fcb66d0cbf62d69ca4b22201c06614db18e33a59"
    sha256 cellar: :any_skip_relocation, catalina:       "9cea92cbfddd03a0c0b94192ec22699d74531be285dd708d82968f60f2d3e731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c0dbb0459472d734c3c9d535a9e7986c44770880d227db0f15c78a40e83626d"
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
