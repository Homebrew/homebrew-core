class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.116.4.tar.gz"
  sha256 "bb849994428ec1e458758597f312ba72100281be01a57e383e667c2d7e32cfd4"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5a8da392e5d34456713373b917b6d4fd62326d0ccb371737d08ced8d9bebb45a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "919ec040e6a34ef5cf3ca83b84cdae182721fe50fd3358dedecb2e58185089b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "678528a429c2995afe5a5fd3a52d06406a280c26e5db335b63012e8d270bbbcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ffd8ef5f8a484a1f4e3236369553096cd94293d24fb580427bcee89a79261d15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f5a3b1412b9a6c9ef0894b38ba82875a46fa0938ce198521f086dea1d9bffe4b"
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
