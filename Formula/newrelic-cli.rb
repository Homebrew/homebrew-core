class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.34.36.tar.gz"
  sha256 "dc4af7cadf593286b8fa38e8696ad1d1e8cb883d9dd46a7b6f24d43aaa3afe1b"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7b46698c4948ac907996b24ef747d270fad2fe3258e4c72766235c74d45293f7"
    sha256 cellar: :any_skip_relocation, big_sur:       "4dbeb8e1c671fd864038408a59767ee9d491c002fab3507a8e514da6f55fa4f6"
    sha256 cellar: :any_skip_relocation, catalina:      "e17438e63d7fd876bea65738c2da02a78145e726220f8e1e7f503619e2c653ee"
    sha256 cellar: :any_skip_relocation, mojave:        "ad966bcf27f18589e65259546291a3c0dcb8b2f87e67a5d7d0ff171af8de5117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b4dc70a724decc86ae3a98fb0319c0265d91d4c20402d2ffd93433813885ca2"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    if OS.mac?
      bin.install "bin/darwin/newrelic"
    else
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
