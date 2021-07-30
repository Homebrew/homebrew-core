class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.32.0.tar.gz"
  sha256 "9bba71e911fe9eccd2599683e9a382208ad970802032e1feeffc6efe704c629b"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6f6de7e27a58452ac9f5cc4b472d3326c42a638fc72496c4d194ef8dd0d8996b"
    sha256 cellar: :any_skip_relocation, big_sur:       "401c971c1ee829519e06759ee2854f671b9b52cd473ca4d1512cb963e7ab915a"
    sha256 cellar: :any_skip_relocation, catalina:      "d8b0238a2b269c8aec40b754f51998c1b93df1ec679d2915e3c1b5aa66986948"
    sha256 cellar: :any_skip_relocation, mojave:        "b42a0083cdc09756d0723a996f248078c7550f277abf4fceefd4487945609db4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1293796668ac289d55b005a9c44b3dcf86e13277625e616d36b83a0910f33565"
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
