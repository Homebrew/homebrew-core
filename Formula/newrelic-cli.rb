class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.30.2.tar.gz"
  sha256 "473acbd3860e44ed07aa114dfa898a6cb293a2d5f4e961d241228992c51be339"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "da2b72b35f38ea993fc4dbe908427301c686d3c81245eb82bd02410be5ff4d43"
    sha256 cellar: :any_skip_relocation, big_sur:       "420799c231c388ae46756915bbc5c268c8f025c711fbf909f45c7717674f54bf"
    sha256 cellar: :any_skip_relocation, catalina:      "070b348c55b96fa2baf8bb7d591eefc9c423cb4b846f114c00489f856377cbb5"
    sha256 cellar: :any_skip_relocation, mojave:        "ae32705d8e12660d1e4fe689b815647ecac9591f469bd9541f39d08647634024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa0094f0b57720d488829a24ebc5c6db31506c8643eb02cc388e040886c1a21c"
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
