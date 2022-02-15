class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.41.22.tar.gz"
  sha256 "3a8fbf3d4f4e0a09782f909b001d758744719f59795c4abf0bfe232ff48428ae"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ef895b2494f21a0b9da9374459b16b64c382b6ecdcb9906dc2ce54764aae936"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a675ad879de8f57585fd8277593c7aa2378fdb854699bfb87d035e61ec72c89f"
    sha256 cellar: :any_skip_relocation, monterey:       "11ae2f08908691ceccc6cc706accdb759976610a2086b8b8ecc2ffc2749a3dc7"
    sha256 cellar: :any_skip_relocation, big_sur:        "dce1ae0f7417c66774120ec0de09ce9cc7e4527bf234a7cad21911984d5f0dbf"
    sha256 cellar: :any_skip_relocation, catalina:       "083e636ec190f3ddaf7019cf89fcb0b96150c46f5e76ea527368569fce33817f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ed12599e56f74c659a4cf98ac1301d307c94d5ba1f70fb0ef31390e69b185ee"
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
