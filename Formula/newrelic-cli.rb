class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.33.1.tar.gz"
  sha256 "4c6007881b67df4b479e3e89f8e06a256951b1957cdf8f1fee24a7da8e52704f"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "36fb4409c6b35e0d1f8b7dd02ff6108227ba84e13099f0e87b15aaf0c4e0f332"
    sha256 cellar: :any_skip_relocation, big_sur:       "b4cdbd4eaeae7dd01974aed032d360d3056389f416b95abef91802c248f7ee5f"
    sha256 cellar: :any_skip_relocation, catalina:      "0ae9addca5944050a24aae726b0154599ee1a724cac61e9fc529b8637912baa0"
    sha256 cellar: :any_skip_relocation, mojave:        "3aa9819cda08cb4fd813b96832fb69719a4c3b6e9d15baa941ce5c1aa7b49d47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63b135e1dfe3f8d5188f90b3e5a921e07a9db9df29b499d95e57b4c5543073f3"
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
