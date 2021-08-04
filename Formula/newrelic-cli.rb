class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.32.2.tar.gz"
  sha256 "95f20e1ac5409c2dd2e25b5bdc54805733e030d6c92076f3bde6545049bc4f62"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f23390e810ec9a9267148f0a0ca213fc28b42d290c5f5e0e24d5060b167339eb"
    sha256 cellar: :any_skip_relocation, big_sur:       "c08a55b259cc507ab127b4bbce8e9053f8041b344fb0781e127751e00352d734"
    sha256 cellar: :any_skip_relocation, catalina:      "6208f5e225c122a544be132ce0282814cd7c2d33e178f97258343eb4a97b1a16"
    sha256 cellar: :any_skip_relocation, mojave:        "4f4143022ae222475d385a100de6e14c8fd506979315caf7a79910c524b02dfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63579bdb274d7bd53bc7cbbe067276fc4fdb5f096eb86d7a402d86d44c972a29"
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
