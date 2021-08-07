class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.32.6.tar.gz"
  sha256 "3ff9a4b69a5cd2f4aa2fa37c8666df70fb164c27f7041437dff912a7a625e505"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b7426a375a7604e02d12cd0b3389d35e0044af0a123a779a6346423783f2f4fa"
    sha256 cellar: :any_skip_relocation, big_sur:       "a77ddd5bfdd5308ef04416c91d7944ec2cf13daba2988ef7f7d84569b658ffb2"
    sha256 cellar: :any_skip_relocation, catalina:      "3cab42743d25be3b02ba8de16a379672074757b242d0d54e9c262390f1898ab9"
    sha256 cellar: :any_skip_relocation, mojave:        "ee986c32d5b3bb89c00663dbd02858583f0490e7b821b4fd633a9bb7e10c0bf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cde7fcdf25b2a7bb211d7f222d8dda0b045336be3737886d327ceb0f199ae17"
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
