class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.42.0.tar.gz"
  sha256 "da5c6675b4690bc8718ab38bf060e2583f309d1a2e4381f11615346fe4f26a1c"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b124a6be8c6f9dd8128d981fd5157abdbf9e02d01f4a703d117a1a84547c799"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00d27bb8d1bf09d1cf676cffbe2ad6198bd5a5b12f211323efab8771c4e01f94"
    sha256 cellar: :any_skip_relocation, monterey:       "08094fdcb6cf881205851bab6321e15678c404baaa09736d61f7538b871d8b0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "66fae3dd9721543e24044068820775da5d81c04660adf6cfe14aa3d286ab9dc3"
    sha256 cellar: :any_skip_relocation, catalina:       "b7d8e8678a350afd2cb54fe7a604bfbbc148331947d3337f679b9b5e19c5af7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "797736b919e94841e42df51ef2ecc6d020474c5c4514cca366d864a5ea256132"
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
