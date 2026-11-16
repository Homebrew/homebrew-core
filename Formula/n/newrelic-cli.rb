class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.116.1.tar.gz"
  sha256 "58a0ba6f77c4bef86c89a9947ab7a69e8daaaa8d6f52f839e5d38e25f8748ab8"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "232a83bb5773415ee1834d5369addda4acb7bf622c47ec9a14f848504a6e0ef7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3506d113b8a494d74bf8ced3162aa6c098342428d63c489df1bc52e29e9e3ead"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d01e5986bf4b8f5d26f4c3ce23c186c8380258fa98d9cf6abce5eb2a9e6651e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "481b032c20359dcaead47e180fa55dc7b3b28f7d161e25654305095a55a7226b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "62660102375978daf633cd23a4d04fe887ced201fdb48641bd2bee76f78b0f25"
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
