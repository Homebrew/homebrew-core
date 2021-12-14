class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.40.3.tar.gz"
  sha256 "74cf60d0e89e587da22cfba0b937dd3669f9c8cf5e41f41b329115a09353f5c4"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e3f90b8ced3ec55f1189134b3da81d246d2b9587e2d9da555b2df335291efb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "959dabfb7071e567c830e0d434851ae790e85a3793dacecdcaf1beb2048c514b"
    sha256 cellar: :any_skip_relocation, monterey:       "493381bc488ba30e2418b4287f122a449f709ec7339795d0bbd1da1c5d32bf2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4566d63925fd9e0d72c50584cf00083d1c17fd71f00aedb775d89772a02f768"
    sha256 cellar: :any_skip_relocation, catalina:       "5e8360677392fe652f422aa126e10677f1a4c882dcb4a6c669ce83e4155c417e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bea6b88fae880c9b1c10e58fa9772339a626f8472dc1f4347af70a45dbd6158"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

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
