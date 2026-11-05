class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.115.8.tar.gz"
  sha256 "358e9f81c8d00f3d360c9e5ee2db71d3bbacb71a6a540cc2ad73379c117d426b"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b96c6266173389fc24834d8f62b3fd0be7dc634ea5822244174414ebb4812ece"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "28d3e3ded03c02189249420ce0e525bb897ee8f64b8fc852982a218c6dcc14a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "49bf52d1b4dd303205b2a743e6bd28029cb5ad03c1abe1b0f9e728d1603f5686"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9b1415249e88add544181f38e84224e059da0956aacdc6cd526c0a7c9ad76716"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "715299ed7c83f5f170e60dfea77c48e1425fa6ea897f857e9e7dd43ffabc26a7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
