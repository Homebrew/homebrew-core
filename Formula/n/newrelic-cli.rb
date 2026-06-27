class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.112.13.tar.gz"
  sha256 "3bc00d7636020206d6fb49a3f8bed883aa3a3b5724930942941afd96b06b4cd7"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52a128a18347d02f53826f9cbd72d4c087851e2ba07ef330821bb523df3d54df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b242d1fee73bc6bd194b8fbcd6bb1a8f4fb10c6fc17033f128fa5a789a3e7247"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de5e6a7815f7194ac9b42481ab9c4ce2c47d1c69c0f532419a973a24aae122bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "82025c066c922ce36919b537ce7caa5a360a4d5ef08ce459516c9012be91b6ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "413bfc2425eb461ac95570599f86957c8ce92fea60fd0097e1d29ce85b63768c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d97c1c0cb779ee9f72ad40b01aa2bcd26b19cdb3dbeb7b7ff8feffbc3365226e"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
