class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.40.1.tar.gz"
  sha256 "32e7588ceafa94ac2302d281244a131889805ab1397f0e5642cd822f4dcbf3ee"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85aa3e465be11b5525c427e511c0ee1f44d779f61f0486bcfbbe7428b492816a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dd79f8712af8821eb894407dcc961d3715da1c08e1b0e1b949151f24531678e"
    sha256 cellar: :any_skip_relocation, monterey:       "554ca30473dec21e72d77010d57c6d739e7a33e85c101e68219cbceb1e125748"
    sha256 cellar: :any_skip_relocation, big_sur:        "f98b9d7fe6ef50a800fb508dcea2c700fcdb89d1649dedee7d65ebe9c13268f4"
    sha256 cellar: :any_skip_relocation, catalina:       "c26ad8d6f7f0e13a29d17e4aed7e0202b829721158046576e4300ac249f2c72f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c82b0f4c95d2a54121a6c0b434db1b03c68be38b96ed291bda10a87d21694bc"
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
