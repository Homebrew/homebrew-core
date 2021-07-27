class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.31.4.tar.gz"
  sha256 "35513551146763c448cf0931d05680a89746abd918f4ff6ccd0b19eec23eb2e1"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "be24e4061b69427179ed9ba281ea8b3be9b46d407da7a67f77f088773a8a87aa"
    sha256 cellar: :any_skip_relocation, big_sur:       "efed05737b252bb16141b80fc3579836d2c719ca93bfb053d48ddfe9735aef24"
    sha256 cellar: :any_skip_relocation, catalina:      "55aacf2d3ab7a300b91b24b801507961628e7d9f6416da65d2ccf2ae0ddeb5ee"
    sha256 cellar: :any_skip_relocation, mojave:        "42e45d5e427bdd60df982c706e104476bf77ee961348dace3220aff8dfcfacec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0103b140a563283f66ca04dbe082de69f6f6d725f72407d4b65948f4d74dc921"
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
