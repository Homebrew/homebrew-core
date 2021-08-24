class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.34.7.tar.gz"
  sha256 "62cea2998a2096fe8ce42d6a5b700c96da7de71d7862c1fafab5b36f742b4e35"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f7e2904354b81fd5e4271f69ba5779652f338af76c15dae84213bb692527bdf9"
    sha256 cellar: :any_skip_relocation, catalina:      "97aea9005ed2236c124e082e9380fc109270c45361b60e6b6141e5f1badd44a3"
    sha256 cellar: :any_skip_relocation, mojave:        "d42c46eec15270db37afee23ecfb898cec1421e591e9e243b1a8fbbaa0f79a57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec5f50a4a9f2ecfdf5d24c11333fbc2cd6ad0f6e5f8ebd7d1799956084c49bec"
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
