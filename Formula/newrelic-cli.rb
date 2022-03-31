class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.44.8.tar.gz"
  sha256 "3185ce47dc61d17718230e7dfc07c89d003e5dbd9e916c4cf308e20d57fd5363"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91ef711cac2dac82bee81888cb2f752c867f64aceb1e843685cfa9f88edab9b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db9edde438a148fed10ed621f69520ad3c8e234420796b7fe45496cace44701d"
    sha256 cellar: :any_skip_relocation, monterey:       "9dfc48e8a392769b5ebe2ddb5a095d6c6c145e1429d701d1fd2019b5ac9a559c"
    sha256 cellar: :any_skip_relocation, big_sur:        "4444844bd4474da94595e13fcdff302bfdd8d616c6266968842671a3307e3003"
    sha256 cellar: :any_skip_relocation, catalina:       "50dea07537970ad8742669708fdba47b58de5fcf6f7744905b3df8403b1d17d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47661f687caa213c7e3ab10c712a46610281a632fd9666e05aaf05de9d2ac7c1"
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
