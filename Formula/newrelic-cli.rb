class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.34.31.tar.gz"
  sha256 "fc900d354e93e4b917cc80aab8e4a5a43ef7a6544193e6a6121dc6b89ed626db"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c0af1a932c6fc2985a9afa87b8024749122a9f1a8b26a6ec20df92ebe7518c73"
    sha256 cellar: :any_skip_relocation, big_sur:       "6d9dc2233d8ace1fb618307f1a8a5ddb6d3943dde7d4f31bbb74caf586393b79"
    sha256 cellar: :any_skip_relocation, catalina:      "5c4071b171ae656482e9a91f5d2fdc69c377119faa2e33405283144842136cc0"
    sha256 cellar: :any_skip_relocation, mojave:        "4f4ace367ae61a60997f8dded34719cad577154eb6d331337e2eeeb7de452d22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9e112f2749632b82792d4ecdb0ccdce311db064b9513ab8f414e3c85f27679a"
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
