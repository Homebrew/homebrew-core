class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.49.12.tar.gz"
  sha256 "182df2b8ead91f1686ed57b500e2891c625018f20ad53a436b31e72bc7020f37"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a25ccd1925ebb3059e17010a06927878953d5ed581117ca3df6764bb2986dbf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fb3560d2d3e8529d901f94a6047517654b2613bd662567c5ca70221f9aaeafe"
    sha256 cellar: :any_skip_relocation, monterey:       "3b2fc068467c4427891e66b33237514d657cae74d495ad93d8e296783254af21"
    sha256 cellar: :any_skip_relocation, big_sur:        "40942824670ca89882fe9ffb7eda640cbe5e01a70bbdaca301de9b70291c04c0"
    sha256 cellar: :any_skip_relocation, catalina:       "caaadfa4250b3e0cc63a06aa7005a71b30e3f0ad3f0dcbfc066d325a17af5b48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9546e6bfb57709a1ab43b994c0242f4af5fcc55c661143949b0f7b5a1f9b6815"
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
