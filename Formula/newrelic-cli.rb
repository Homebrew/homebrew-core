class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.30.1.tar.gz"
  sha256 "c7c752d59882d778a6c2e476d9859ab8528648bf279c2bf55527387181acf2b1"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "31be3281e0b9a7fdf030ca8198611a3cf79a76017b23dc269d1f6c5910827172"
    sha256 cellar: :any_skip_relocation, big_sur:       "6b6a667272a2fb5ba9bdac8362ad90dc58efba2f8b2e1e5ded9175f0077df003"
    sha256 cellar: :any_skip_relocation, catalina:      "fbc23c786578100c72168022d78950be758640f07c27e580c0afed19c62581b1"
    sha256 cellar: :any_skip_relocation, mojave:        "d34559b94e0be211339113189b9ee4b22d44d706b168a787d289cbad363f0a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06ebbf342410258291c9a80c6267351526849fdff3df3be0815de1c6069614fd"
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
