class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.28.11.tar.gz"
  sha256 "c45a6778bd30254f653f55cb71ec80f730f7b89e836f7a7b9649fa33a4d80de9"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "585729dcff576ddf1d6aa3b42c03e6fe7632db8a6e490d2a5310566c90ea11c6"
    sha256 cellar: :any_skip_relocation, big_sur:       "b249a7be907199e4ec871d6e5e9742e6e379601c56bb8b62246414b52c98a4b6"
    sha256 cellar: :any_skip_relocation, catalina:      "b12501c1e3ba5c098b3eab86ff1cffe81fa7ca963b72302466a3b784d65bbc7f"
    sha256 cellar: :any_skip_relocation, mojave:        "40f1921fb1374a62e1e8a03fbb32e05cc53a77d53de35769302eb57cd7ac1668"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/darwin/newrelic"

    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
  end

  test do
    assert_match "pluginDir", shell_output("#{bin}/newrelic config list")
    assert_match "logLevel", shell_output("#{bin}/newrelic config list")
    assert_match "sendUsageData", shell_output("#{bin}/newrelic config list")
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
