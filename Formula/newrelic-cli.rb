class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.42.2.tar.gz"
  sha256 "3a9dff7f4af993dfeb9135e639f6c0638200a6635f87fd428ecabc73a282d4f3"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19b3bde0cfa873d49a0ace0c2fc3233c274d5150a45d14641c4be380bea0efce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4dba363aa1626cf9bcc66f67ab87a7e6445adda7542deea926170510d3adb920"
    sha256 cellar: :any_skip_relocation, monterey:       "98b547167a0362e1169988ed83e16a2057a0308fda7ce26656a851689db16631"
    sha256 cellar: :any_skip_relocation, big_sur:        "252bd6789c55aa58304890e544b1f61f5d067766a0160440adb18930ef77e300"
    sha256 cellar: :any_skip_relocation, catalina:       "16ed1d9ea1e41167f0ab3c20a57561546b2d93fda2a0e9e86dc64e650aa4439c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98c9a82dc402743a73eda4c1ea7b1fd6bb634d2d259aa266b2b71c3d70cb15c9"
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
