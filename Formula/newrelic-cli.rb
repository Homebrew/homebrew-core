class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.40.4.tar.gz"
  sha256 "ec943ab2bb6b53579c55242731b25137255f0259a797339a46d76a414f88dc56"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4bc9bed814ddae39166d30f1d402e0c876ad3c0b9ec764b01a8acbaffc6b621"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f067ca88ab30db1e99e42ef057f945d9dab10b652085a70a7160cecc81545cdf"
    sha256 cellar: :any_skip_relocation, monterey:       "60f61eb288dfdbaf39f85f272896e9965794c744875b229b4547ce5185ef4543"
    sha256 cellar: :any_skip_relocation, big_sur:        "55fae3f16cad139dbc9c67a441c577b332dfd07e093f1de3499271464a57cab5"
    sha256 cellar: :any_skip_relocation, catalina:       "2cfc6e6bcf67c0cc31ce902581bb595dd2a66a1930d1b2b226fe20ecd8b66f44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8191a17fa19464a313e27720967f2cc970fe91886c898ae9addb4e8bf069766c"
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
