class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.41.1.tar.gz"
  sha256 "3766b224600355cb846cd20ac4857480c18b20fc2488c561180f148ba3124614"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14939311d563159e375ba4f102bac1d9697cf663579035cf1265b277b5a4c377"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aad1a6d90e0af190d1326ef1ba9632b6a0f7bc070410d827e8c3845bee74d125"
    sha256 cellar: :any_skip_relocation, monterey:       "90b3fcbbdf620cdab5f4c5b77340598a969d7ee10acb9d4bd5a9796b741b07c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d823af55166cea573e59f793bc68b0924588c4b1066cad2496486b0d4104722"
    sha256 cellar: :any_skip_relocation, catalina:       "09e8686cf8095cbbd98b2a127911eb4302670d3ac77a4c22ac09adf581384ef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4e99af3222938def7b813369e36d1ad2341bed04ee64d54ef5bd1e1adbf8b53"
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
