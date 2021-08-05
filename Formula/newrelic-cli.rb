class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.32.2.tar.gz"
  sha256 "95f20e1ac5409c2dd2e25b5bdc54805733e030d6c92076f3bde6545049bc4f62"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2bfa6cef7bb0f356d7556cc77585ef7bdd4a1004f5c65db22d346fe22aaa3ad8"
    sha256 cellar: :any_skip_relocation, big_sur:       "74c0687ff640d86eab32c088db81befebdc41e8fc66a8035b76a9f3acc4b0378"
    sha256 cellar: :any_skip_relocation, catalina:      "748fb62f9eff1d5601d13f0c4a1ee61179a1289fcc3ee8d0eda34a2f4342f55c"
    sha256 cellar: :any_skip_relocation, mojave:        "bf2184dc06297a5a8aa2adc180a68db90c63022f5ea9ff04c26e92cb9dc2b3f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b31b0867b52f4c81a9ffd77e7e0c3cdf78d1e6e7c26f16e44f98d2b0234c353"
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
