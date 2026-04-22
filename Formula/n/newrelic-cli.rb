class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.111.7.tar.gz"
  sha256 "ca0a18c60c25eeb289bcd99d6d8d910eb1b79c97f17c1db6667a8d6389017b50"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f8fd0d3c34c8db2ce377d7feebc08ee84a1816679bb991f1e6bc7c1db3d5f4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f1de159d79a47a4ea2509091211fa0ed7992ab127ab1c5ae97fb7336811df93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8599fc559025a26dd0da6c1071e75f42481024013091eda4697e320a6604d851"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffb18cef77bc7aeffc6247d1de680ea3ab08aab0a6ad81fd18bd3725b355e763"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8aaa21eacae3c493b0b95c86fe0ffd4b59c4c97eacd0fa6b26345a54f79ff2e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c9d5489f6f3943f179964c9f0e78a5365903733ee2cb4985361c4bd318481a6"
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
