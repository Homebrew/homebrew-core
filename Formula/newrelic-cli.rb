class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.34.39.tar.gz"
  sha256 "b1558f644bf8532aabeee06af44412ed971e44da14d93b338a382fc15ce547c2"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "be776154cb95683e89add935f64a2bb2eb09e19880b9628ea02191e841ac75b0"
    sha256 cellar: :any_skip_relocation, big_sur:       "11325ce8822cdbe6a17493b4f46de8a815dbf949cd057a850e52cdc4c4cfd562"
    sha256 cellar: :any_skip_relocation, catalina:      "8570529a89d519567fb8fdfd18cef33ec6dbebf5f0a11d8ea8090ceb4133df8a"
    sha256 cellar: :any_skip_relocation, mojave:        "4419b0b0e034c2daa483fda8f644655f6cf0bbb30c6478b79e0c8d33df887634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77ebd751fd29f20f4998c367c454fdaa2400197a1d9767634e04d7610b0128df"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    if OS.mac?
      bin.install "bin/darwin/newrelic"
    else
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
